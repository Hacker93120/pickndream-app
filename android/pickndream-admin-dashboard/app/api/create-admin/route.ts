import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { hashPassword } from "@/lib/auth";

export async function POST(req: Request) {
  try {
    console.log('🔐 Création du compte admin...');
    
    const hashedPassword = await hashPassword("admin123");
    
    const admin = await prisma.user.upsert({
      where: { email: "admin@pickndream.fr" },
      update: {
        password: hashedPassword,
        role: "ADMIN"
      },
      create: {
        email: "admin@pickndream.fr",
        password: hashedPassword,
        name: "Administrateur PicknDream",
        role: "ADMIN",
        phone: "+33612345678",
      },
    });
    
    return NextResponse.json({
      success: true,
      message: "Compte admin créé avec succès !",
      credentials: {
        email: "admin@pickndream.fr",
        password: "admin123",
        role: "ADMIN"
      }
    });
    
  } catch (error) {
    console.error('❌ Erreur:', error);
    return NextResponse.json(
      { success: false, message: "Erreur lors de la création du compte admin" },
      { status: 500 }
    );
  }
}
