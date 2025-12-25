import { NextResponse } from "next/server";
import { createPool } from "@vercel/postgres";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "fallback-secret-change-in-production";

export const dynamic = 'force-dynamic';

export async function POST(req: Request) {
  try {
    const { email, password } = await req.json();

    if (!email || !password) {
      return NextResponse.json(
        { success: false, message: "Email et mot de passe requis." },
        { status: 400 }
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
      SELECT id, email, password, name, role, phone, "photoUrl"
      FROM "User" 
      WHERE email = ${email.toLowerCase()}
    `;

    if (result.rows.length === 0) {
      return NextResponse.json(
        { success: false, message: "Email ou mot de passe incorrect." },
        { status: 401 }
      );
    }

    const user = result.rows[0];

    // Vérifier que c'est un admin
    if (user.role !== "ADMIN") {
      return NextResponse.json(
        { success: false, message: "Accès réservé aux administrateurs." },
        { status: 403 }
      );
    }

    const isValid = await bcrypt.compare(password, user.password);
    if (!isValid) {
      return NextResponse.json(
        { success: false, message: "Email ou mot de passe incorrect." },
        { status: 401 }
      );
    }

    const token = jwt.sign({
      userId: user.id,
      email: user.email,
      role: user.role,
    }, JWT_SECRET, { expiresIn: "30d" });

    return NextResponse.json({
      success: true,
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role.toLowerCase(),
        phone: user.phone,
        photoUrl: user.photoUrl,
        stats: {
          trips: 0,
          bookings: 0,
          revenue: 0,
          hotels: 0,
        },
      },
    });
  } catch (error) {
    console.error("Login error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur, réessayez." },
      { status: 500 }
    );
  }
}
