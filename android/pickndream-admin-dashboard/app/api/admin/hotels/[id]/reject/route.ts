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

    // Récupérer la raison du rejet
    const body = await req.json();
    const { reason } = body;

    // Rejeter l'hôtel
    const hotel = await prisma.hotel.update({
      where: { id: params.id },
      data: {
        status: "INACTIVE",
        rejectionReason: reason || "Non conforme",
      },
    });

    return NextResponse.json({
      success: true,
      message: "Hôtel rejeté",
      hotel,
    });
  } catch (error) {
    console.error("Erreur rejet hôtel:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
