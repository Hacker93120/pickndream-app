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
        h.id,
        h.name,
        h.description,
        h.city,
        h.address,
        h.country,
        h.rating,
        h."pricePerNight",
        h.status,
        h."photoUrl",
        h."createdAt",
        h."updatedAt",
        COUNT(DISTINCT b.id) as bookings_count
      FROM "Hotel" h
      LEFT JOIN "Booking" b ON h.id = b."hotelId"
      GROUP BY h.id, h.name, h.description, h.city, h.address, h.country, h.rating, h."pricePerNight", h.status, h."photoUrl", h."createdAt", h."updatedAt"
      ORDER BY h."createdAt" DESC
    `;

    return NextResponse.json({
      success: true,
      hotels: result.rows
    });

  } catch (error) {
    console.error("Admin hotels error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}

export async function POST(req: Request) {
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

    const { name, description, city, address, country, pricePerNight, photoUrl } = await req.json();

    const connectionString = process.env.PICKNDREAM_POSTGRES_URL || process.env.PICKNDREAM_DATABASE_URL;

    if (!connectionString) {
      return NextResponse.json(
        { success: false, message: "Erreur de configuration" },
        { status: 500 }
      );
    }

    const db = createPool({ connectionString });

    const result = await db.sql`
      INSERT INTO "Hotel" (id, name, description, city, address, country, "pricePerNight", status, "photoUrl", rating, "createdAt", "updatedAt")
      VALUES (gen_random_uuid(), ${name}, ${description}, ${city}, ${address}, ${country || 'France'}, ${pricePerNight}, 'ACTIVE', ${photoUrl || null}, 0, NOW(), NOW())
      RETURNING *
    `;

    return NextResponse.json({
      success: true,
      hotel: result.rows[0]
    });

  } catch (error) {
    console.error("Create hotel error:", error);
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

    const { hotelId, status } = await req.json();

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
      SET status = ${status}, "updatedAt" = NOW()
      WHERE id = ${hotelId}
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

export async function DELETE(req: Request) {
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

    const { hotelId } = await req.json();

    const connectionString = process.env.PICKNDREAM_POSTGRES_URL || process.env.PICKNDREAM_DATABASE_URL;

    if (!connectionString) {
      return NextResponse.json(
        { success: false, message: "Erreur de configuration" },
        { status: 500 }
      );
    }

    const db = createPool({ connectionString });

    await db.sql`DELETE FROM "Hotel" WHERE id = ${hotelId}`;

    return NextResponse.json({
      success: true,
      message: "Hôtel supprimé"
    });

  } catch (error) {
    console.error("Delete hotel error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
