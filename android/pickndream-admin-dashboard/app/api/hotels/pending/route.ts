import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function GET() {
  try {
    const pendingHotels = await prisma.hotel.findMany({
      where: {
        status: "PENDING_REVIEW"
      },
      orderBy: {
        createdAt: "desc"
      }
    });

    return NextResponse.json({ 
      hotels: pendingHotels,
      count: pendingHotels.length 
    });
  } catch (error) {
    console.error("Error:", error);
    return NextResponse.json({ error: "Erreur serveur" }, { status: 500 });
  }
}
