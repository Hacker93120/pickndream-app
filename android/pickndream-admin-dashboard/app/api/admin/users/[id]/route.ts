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

    const [userResult, bookingsResult] = await Promise.all([
      db.sql`
        SELECT id, email, name, role, phone, "photoUrl", "createdAt", "updatedAt"
        FROM "User"
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
          h.name as hotel_name,
          h.city as hotel_city
        FROM "Booking" b
        LEFT JOIN "Hotel" h ON b."hotelId" = h.id
        WHERE b."userId" = ${params.id}
        ORDER BY b."createdAt" DESC
      `
    ]);

    if (userResult.rows.length === 0) {
      return NextResponse.json(
        { success: false, message: "Utilisateur non trouvé" },
        { status: 404 }
      );
    }

    return NextResponse.json({
      success: true,
      user: userResult.rows[0],
      bookings: bookingsResult.rows
    });

  } catch (error) {
    console.error("Get user error:", error);
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

    const { name, email, phone, role } = await req.json();

    const connectionString = process.env.PICKNDREAM_POSTGRES_URL || process.env.PICKNDREAM_DATABASE_URL;

    if (!connectionString) {
      return NextResponse.json(
        { success: false, message: "Erreur de configuration" },
        { status: 500 }
      );
    }

    const db = createPool({ connectionString });

    await db.sql`
      UPDATE "User"
      SET name = ${name}, email = ${email}, phone = ${phone}, role = ${role}, "updatedAt" = NOW()
      WHERE id = ${params.id}
    `;

    return NextResponse.json({
      success: true,
      message: "Utilisateur mis à jour"
    });

  } catch (error) {
    console.error("Update user error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
