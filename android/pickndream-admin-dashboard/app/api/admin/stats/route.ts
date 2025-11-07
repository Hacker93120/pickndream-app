import { NextResponse } from "next/server";
import { createPool } from "@vercel/postgres";
import { verifyToken } from "@/lib/auth";

export const dynamic = 'force-dynamic';

export async function GET(req: Request) {
  try {
    const authHeader = req.headers.get("authorization");
    const token = authHeader?.replace("Bearer ", "");

    if (!token) {
      return NextResponse.json(
        { success: false, message: "Token manquant" },
        { status: 401 }
      );
    }

    const payload = verifyToken(token);
    if (!payload || payload.role !== "ADMIN") {
      return NextResponse.json(
        { success: false, message: "Accès non autorisé" },
        { status: 403 }
      );
    }

    const connectionString = process.env.PICKNDREAM_POSTGRES_URL || process.env.PICKNDREAM_DATABASE_URL;

    if (!connectionString) {
      return NextResponse.json(
        { success: false, message: "Erreur de configuration" },
        { status: 500 }
      );
    }

    const db = createPool({ connectionString });

    // Récupérer toutes les stats en parallèle
    const [
      totalUsersResult,
      totalHotelsResult,
      totalBookingsResult,
      activeHotelsResult,
      pendingBookingsResult,
      completedBookingsResult,
      recentBookingsResult,
      totalRevenueResult
    ] = await Promise.all([
      db.sql`SELECT COUNT(*) as count FROM "User"`,
      db.sql`SELECT COUNT(*) as count FROM "Hotel"`,
      db.sql`SELECT COUNT(*) as count FROM "Booking"`,
      db.sql`SELECT COUNT(*) as count FROM "Hotel" WHERE status = 'ACTIVE'`,
      db.sql`SELECT COUNT(*) as count FROM "Booking" WHERE status = 'PENDING'`,
      db.sql`SELECT COUNT(*) as count FROM "Booking" WHERE status = 'COMPLETED'`,
      db.sql`SELECT COUNT(*) as count FROM "Booking" WHERE "createdAt" >= NOW() - INTERVAL '7 days'`,
      db.sql`SELECT SUM("totalPrice") as total FROM "Booking" WHERE status IN ('COMPLETED', 'CONFIRMED')`
    ]);

    const stats = {
      totalUsers: Number(totalUsersResult.rows[0].count),
      totalHotels: Number(totalHotelsResult.rows[0].count),
      totalBookings: Number(totalBookingsResult.rows[0].count),
      activeHotels: Number(activeHotelsResult.rows[0].count),
      pendingBookings: Number(pendingBookingsResult.rows[0].count),
      completedBookings: Number(completedBookingsResult.rows[0].count),
      recentBookings: Number(recentBookingsResult.rows[0].count),
      totalRevenue: Number(totalRevenueResult.rows[0].total || 0)
    };

    return NextResponse.json({
      success: true,
      stats
    });

  } catch (error) {
    console.error("Admin stats error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
