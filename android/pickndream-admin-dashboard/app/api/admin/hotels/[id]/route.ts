import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { verifyToken } from "@/lib/auth";

export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    // Vérifier l'authentification
    const token = req.headers.get("authorization")?.replace("Bearer ", "");
    if (!token) {
      return NextResponse.json(
        { success: false, message: "Non autorisé" },
        { status: 401 }
      );
    }

    const payload = verifyToken(token);
    if (!payload) {
      return NextResponse.json(
        { success: false, message: "Token invalide" },
        { status: 403 }
      );
    }

    // Récupérer l'hôtel
    const hotel = await prisma.hotel.findUnique({
      where: { id: params.id },
      include: {
        owner: {
          select: {
            id: true,
            name: true,
            email: true,
          },
        },
      },
    });

    if (!hotel) {
      return NextResponse.json(
        { success: false, message: "Hôtel non trouvé" },
        { status: 404 }
      );
    }

    return NextResponse.json({
      success: true,
      hotel,
    });
  } catch (error) {
    console.error("Erreur récupération hôtel:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
