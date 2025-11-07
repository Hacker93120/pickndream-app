import { NextResponse } from "next/server";
import { createPool } from "@vercel/postgres";
import { verifyToken } from "@/lib/auth";

export const dynamic = 'force-dynamic';

export async function GET(
  req: Request,
  { params }: { params: { id: string } }
) {
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
        b."updatedAt",
        u.name as user_name,
        u.email as user_email,
        u.phone as user_phone,
        h.name as hotel_name,
        h.city as hotel_city,
        h.address as hotel_address,
        h.country as hotel_country,
        h."photoUrl" as hotel_photo
      FROM "Booking" b
      LEFT JOIN "User" u ON b."userId" = u.id
      LEFT JOIN "Hotel" h ON b."hotelId" = h.id
      WHERE b.id = ${params.id}
    `;

    if (result.rows.length === 0) {
      return NextResponse.json(
        { success: false, message: "Réservation non trouvée" },
        { status: 404 }
      );
    }

    return NextResponse.json({
      success: true,
      booking: result.rows[0]
    });

  } catch (error) {
    console.error("Get booking error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
