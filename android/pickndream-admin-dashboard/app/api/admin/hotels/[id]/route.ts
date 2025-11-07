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

    const [hotelResult, bookingsResult] = await Promise.all([
      db.sql`
        SELECT id, name, description, city, address, country, rating, "pricePerNight", status, "photoUrl", "createdAt", "updatedAt"
        FROM "Hotel"
        WHERE id = ${params.id}
      `,
      db.sql`
        SELECT
          b.id,
          b."checkIn",
          b."checkOut",
          b."totalPrice",
          b.status,
          b."createdAt",
          u.name as user_name,
          u.email as user_email
        FROM "Booking" b
        LEFT JOIN "User" u ON b."userId" = u.id
        WHERE b."hotelId" = ${params.id}
        ORDER BY b."createdAt" DESC
      `
    ]);

    if (hotelResult.rows.length === 0) {
      return NextResponse.json(
        { success: false, message: "Hôtel non trouvé" },
        { status: 404 }
      );
    }

    return NextResponse.json({
      success: true,
      hotel: hotelResult.rows[0],
      bookings: bookingsResult.rows
    });

  } catch (error) {
    console.error("Get hotel error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}

export async function PATCH(
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

    const { name, description, city, address, country, rating, pricePerNight, photoUrl } = await req.json();

    const connectionString = process.env.PICKNDREAM_POSTGRES_URL || process.env.PICKNDREAM_DATABASE_URL;

    if (!connectionString) {
      return NextResponse.json(
        { success: false, message: "Erreur de configuration" },
        { status: 500 }
      );
    }

    const db = createPool({ connectionString });

    await db.sql`
      UPDATE "Hotel"
      SET name = ${name}, description = ${description}, city = ${city}, address = ${address},
          country = ${country}, rating = ${rating}, "pricePerNight" = ${pricePerNight},
          "photoUrl" = ${photoUrl}, "updatedAt" = NOW()
      WHERE id = ${params.id}
    `;

    return NextResponse.json({
      success: true,
      message: "Hôtel mis à jour"
    });

  } catch (error) {
    console.error("Update hotel error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
