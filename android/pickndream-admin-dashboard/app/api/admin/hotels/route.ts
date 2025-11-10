import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { verifyToken } from "@/lib/auth";

export async function GET(req: NextRequest) {
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

    // Récupérer le filtre de statut depuis l'URL
    const { searchParams } = new URL(req.url);
    const statusFilter = searchParams.get("status") || "all";

    // Construire la requête selon le filtre
    let whereClause: any = {};

    if (statusFilter === "PENDING") {
      // Chercher les hôtels en attente (PENDING ou PENDING_REVIEW)
      whereClause = {
        OR: [
          { status: "PENDING" },
          { status: "PENDING_REVIEW" }
        ]
      };
    } else if (statusFilter === "ACTIVE") {
      // Chercher les hôtels approuvés (APPROVED ou ACTIVE)
      whereClause = {
        OR: [
          { status: "APPROVED" },
          { status: "ACTIVE" }
        ]
      };
    } else if (statusFilter === "INACTIVE") {
      // Chercher les hôtels rejetés (REJECTED ou INACTIVE)
      whereClause = {
        OR: [
          { status: "REJECTED" },
          { status: "INACTIVE" }
        ]
      };
    }
    // Si "all", on ne met pas de filtre de statut

    const hotels = await prisma.hotel.findMany({
      where: whereClause,
      include: {
        owner: {
          select: {
            id: true,
            name: true,
            email: true,
          },
        },
      },
      orderBy: {
        createdAt: "desc",
      },
    });

    return NextResponse.json({
      success: true,
      hotels,
      count: hotels.length,
    });
  } catch (error) {
    console.error("Erreur chargement hôtels:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
