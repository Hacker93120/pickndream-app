import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { verifyToken } from '@/lib/auth';

/**
 * GET /api/admin/users - Liste tous les utilisateurs inscrits
 */
export async function GET(req: Request) {
  try {
    // Vérifier l'authentification admin
    const authHeader = req.headers.get('authorization');
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return NextResponse.json(
        { success: false, message: 'Non autorisé' },
        { status: 401 }
      );
    }

    const token = authHeader.replace('Bearer ', '');
    const payload = await verifyToken(token);

    if (!payload) {
      return NextResponse.json(
        { success: false, message: 'Token invalide' },
        { status: 401 }
      );
    }

    // Vérifier que c'est un admin
    const user = await prisma.user.findUnique({
      where: { id: payload.userId }
    });

    if (!user || user.role !== 'ADMIN') {
      return NextResponse.json(
        { success: false, message: 'Accès refusé - Admin requis' },
        { status: 403 }
      );
    }

    console.log(`📋 Admin ${user.email} consulte la liste des utilisateurs`);

    // Récupérer tous les utilisateurs avec leurs statistiques
    const users = await prisma.user.findMany({
      select: {
        id: true,
        email: true,
        name: true,
        role: true,
        phone: true,
        photoUrl: true,
        createdAt: true,
        _count: {
          select: {
            bookings: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    // Formater les données
    const formattedUsers = users.map(user => ({
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      phone: user.phone,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt,
      bookings_count: user._count.bookings
    }));

    console.log(`✅ ${formattedUsers.length} utilisateurs récupérés`);

    return NextResponse.json({
      success: true,
      users: formattedUsers,
      count: formattedUsers.length
    });
  } catch (error: any) {
    console.error('❌ Erreur récupération utilisateurs:', error);
    return NextResponse.json(
      { success: false, message: error.message },
      { status: 500 }
    );
  }
}

/**
 * DELETE /api/admin/users - Supprimer un utilisateur
 */
export async function DELETE(req: Request) {
  try {
    // Vérifier l'authentification admin
    const authHeader = req.headers.get('authorization');
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return NextResponse.json(
        { success: false, message: 'Non autorisé' },
        { status: 401 }
      );
    }

    const token = authHeader.replace('Bearer ', '');
    const payload = await verifyToken(token);

    if (!payload) {
      return NextResponse.json(
        { success: false, message: 'Token invalide' },
        { status: 401 }
      );
    }

    // Vérifier que c'est un admin
    const admin = await prisma.user.findUnique({
      where: { id: payload.userId }
    });

    if (!admin || admin.role !== 'ADMIN') {
      return NextResponse.json(
        { success: false, message: 'Accès refusé - Admin requis' },
        { status: 403 }
      );
    }

    const { userId } = await req.json();

    if (!userId) {
      return NextResponse.json(
        { success: false, message: 'ID utilisateur requis' },
        { status: 400 }
      );
    }

    // Empêcher la suppression d'un admin
    const userToDelete = await prisma.user.findUnique({
      where: { id: userId }
    });

    if (userToDelete?.role === 'ADMIN') {
      return NextResponse.json(
        { success: false, message: 'Impossible de supprimer un administrateur' },
        { status: 403 }
      );
    }

    console.log(`🗑️ Admin ${admin.email} supprime l'utilisateur ${userId}`);

    // Supprimer les réservations de l'utilisateur d'abord
    await prisma.booking.deleteMany({
      where: { userId: userId }
    });

    // Supprimer l'utilisateur
    await prisma.user.delete({
      where: { id: userId }
    });

    console.log(`✅ Utilisateur ${userId} supprimé avec succès`);

    return NextResponse.json({
      success: true,
      message: 'Utilisateur supprimé avec succès'
    });
  } catch (error: any) {
    console.error('❌ Erreur suppression utilisateur:', error);
    return NextResponse.json(
      { success: false, message: error.message },
      { status: 500 }
    );
  }
}
