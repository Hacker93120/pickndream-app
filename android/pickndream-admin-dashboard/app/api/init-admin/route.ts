import { NextResponse } from "next/server";
import { createPool } from "@vercel/postgres";
import bcrypt from "bcryptjs";

export const dynamic = 'force-dynamic';

export async function GET() {
  try {
    const hashedPassword = await bcrypt.hash("admin123", 10);

    const connectionString = process.env.PICKNDREAM_POSTGRES_URL || process.env.PICKNDREAM_DATABASE_URL;

    if (!connectionString) {
      return NextResponse.json(
        { success: false, message: "Variable de connexion manquante" },
        { status: 500 }
      );
    }

    const db = createPool({ connectionString });

    const result = await db.sql`
      INSERT INTO "User" (id, email, password, name, role, phone, "createdAt", "updatedAt")
      VALUES (gen_random_uuid(), 'admin@pickndream.fr', ${hashedPassword}, 'Administrateur PicknDream', 'ADMIN', '+33612345678', NOW(), NOW())
      ON CONFLICT (email)
      DO UPDATE SET password = ${hashedPassword}, role = 'ADMIN'
      RETURNING id, email, role;
    `;

    return NextResponse.json({
      success: true,
      message: "Admin créé avec succès !",
      credentials: {
        email: "admin@pickndream.fr",
        password: "admin123"
      },
      data: result.rows[0]
    });
  } catch (error) {
    return NextResponse.json(
      { success: false, message: String(error) },
      { status: 500 }
    );
  }
}
