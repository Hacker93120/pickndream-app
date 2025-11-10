import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { verifyToken } from "@/lib/auth";

export async function PATCH(
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
    if (!payload || payload.role !== "ADMIN") {
      return NextResponse.json(
        { success: false, message: "Accès refusé" },
        { status: 403 }
      );
    }

    // Approuver l'hôtel
    const hotel = await prisma.hotel.update({
      where: { id: params.id },
      data: {
        status: "ACTIVE",
        rejectionReason: null,
      },
    });

    return NextResponse.json({
      success: true,
      message: "Hôtel approuvé avec succès",
      hotel,
    });
  } catch (error) {
    console.error("Erreur approbation hôtel:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
