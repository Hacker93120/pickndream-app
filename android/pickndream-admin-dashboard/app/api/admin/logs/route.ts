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

    // Pour l'instant, on récupère les dernières actions à partir des tables existantes
    // TODO: Créer une vraie table de logs pour tracker toutes les actions

    // Récupérer les derniers utilisateurs créés
    const usersResult = await db.sql`
      SELECT id, name, email, "createdAt", "updatedAt"
      FROM "User"
      ORDER BY "createdAt" DESC
      LIMIT 50
    `;

    // Récupérer les derniers hôtels créés/modifiés
    const hotelsResult = await db.sql`
      SELECT id, name, "createdAt", "updatedAt"
      FROM "Hotel"
      ORDER BY "updatedAt" DESC
      LIMIT 50
    `;

    // Récupérer les dernières réservations
    const bookingsResult = await db.sql`
      SELECT b.id, b."createdAt", b."updatedAt", b.status, u.name as user_name, h.name as hotel_name
      FROM "Booking" b
      LEFT JOIN "User" u ON b."userId" = u.id
      LEFT JOIN "Hotel" h ON b."hotelId" = h.id
      ORDER BY b."updatedAt" DESC
      LIMIT 50
    `;

    // Générer des logs à partir de ces données
    const logs: any[] = [];

    // Logs des utilisateurs
    usersResult.rows.forEach((user: any) => {
      const isNew = new Date(user.createdAt).getTime() === new Date(user.updatedAt).getTime();
      logs.push({
        id: `user-${user.id}-${isNew ? 'create' : 'update'}`,
        action: isNew ? "Création d'utilisateur" : "Modification d'utilisateur",
        user: "Admin",
        details: `Utilisateur: ${user.name} (${user.email})`,
        timestamp: isNew ? user.createdAt : user.updatedAt,
        type: isNew ? "CREATE" : "UPDATE"
      });
    });

    // Logs des hôtels
    hotelsResult.rows.forEach((hotel: any) => {
      const isNew = new Date(hotel.createdAt).getTime() === new Date(hotel.updatedAt).getTime();
      logs.push({
        id: `hotel-${hotel.id}-${isNew ? 'create' : 'update'}`,
        action: isNew ? "Création d'hôtel" : "Modification d'hôtel",
        user: "Admin",
        details: `Hôtel: ${hotel.name}`,
        timestamp: isNew ? hotel.createdAt : hotel.updatedAt,
        type: isNew ? "CREATE" : "UPDATE"
      });
    });

    // Logs des réservations
    bookingsResult.rows.forEach((booking: any) => {
      const isNew = new Date(booking.createdAt).getTime() === new Date(booking.updatedAt).getTime();
      logs.push({
        id: `booking-${booking.id}-${isNew ? 'create' : 'update'}`,
        action: isNew ? "Nouvelle réservation" : `Réservation ${booking.status}`,
        user: "Admin",
        details: `${booking.user_name} → ${booking.hotel_name}`,
        timestamp: isNew ? booking.createdAt : booking.updatedAt,
        type: isNew ? "CREATE" : "UPDATE"
      });
    });

    // Trier les logs par date décroissante
    logs.sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime());

    return NextResponse.json({
      success: true,
      logs: logs.slice(0, 100) // Limiter à 100 logs
    });

  } catch (error) {
    console.error("Get logs error:", error);
    return NextResponse.json(
      { success: false, message: "Erreur serveur" },
      { status: 500 }
    );
  }
}
