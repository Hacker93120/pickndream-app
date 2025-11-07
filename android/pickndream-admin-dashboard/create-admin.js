const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

const prisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.PICKNDREAM_POSTGRES_PRISMA_URL || process.env.PICKNDREAM_DATABASE_URL || process.env.DATABASE_URL
    }
  }
});

async function createAdmin() {
  try {
    console.log('🔐 Création du compte admin...');
    
    const hashedPassword = await bcrypt.hash("admin123", 10);
    
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
    
    console.log('✅ Compte admin créé avec succès !');
    console.log('📧 Email: admin@pickndream.fr');
    console.log('🔑 Mot de passe: admin123');
    console.log('👑 Rôle: ADMIN');
    
  } catch (error) {
    console.error('❌ Erreur:', error);
  } finally {
    await prisma.$disconnect();
  }
}

createAdmin();
