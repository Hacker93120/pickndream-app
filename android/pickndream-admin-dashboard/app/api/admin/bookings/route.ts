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

    const result = await db.sql`
      SELECT
        b.id,
        b."userId",
        b."hotelId",
        b."checkIn",
        b."checkOut",
        b."totalPrice",
        b.status,
        b."createdAt",
        u.name as user_name,
        u.email as user_email,
        h.name as hotel_name,
        h.city as hotel_city
      FROM "Booking" b
      LEFT JOIN "User" u ON b."userId" = u.id
      LEFT JOIN "Hotel" h ON b."hotelId" = h.id
      ORDER BY b."createdAt" DESC
    `;

    return NextResponse.json({
      success: true,
      bookings: result.rows
    });

  } catch (error) {
    console.error("Admin bookings error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}

export async function PATCH(req: Request) {
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

    const { bookingId, status } = await req.json();

    const connectionString = process.env.PICKNDREAM_POSTGRES_URL || process.env.PICKNDREAM_DATABASE_URL;

    if (!connectionString) {
      return NextResponse.json(
        { success: false, message: "Erreur de configuration" },
        { status: 500 }
      );
    }

    const db = createPool({ connectionString });

    await db.sql`
      UPDATE "Booking"
      SET status = ${status}, "updatedAt" = NOW()
      WHERE id = ${bookingId}
    `;

    return NextResponse.json({
      success: true,
      message: "Réservation mise à jour"
    });

  } catch (error) {
    console.error("Update booking error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
