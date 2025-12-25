import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function POST(req: Request, { params }: { params: { id: string } }) {
  try {
    const { action, reason } = await req.json();
    
    await prisma.hotel.update({
      where: { id: params.id },
      data: {
        status: action === "approve" ? "APPROVED" : "REJECTED",
        rejectionReason: action === "reject" ? reason : null
      }
    });

    return NextResponse.json({ 
      success: true, 
      message: action === "approve" ? "Hôtel approuvé" : "Hôtel rejeté"
    });
  } catch (error) {
    console.error("Error:", error);
    return NextResponse.json({ error: "Erreur serveur" }, { status: 500 });
  }
}
