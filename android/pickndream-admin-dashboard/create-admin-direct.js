const { Client } = require('pg');
const bcrypt = require('bcryptjs');

const connectionString = "postgresql://neondb_owner:npg_kAzYm69SqERw@ep-little-surf-abyqhtq8-pooler.eu-west-2.aws.neon.tech/neondb?sslmode=require";

async function createAdmin() {
  const client = new Client({ connectionString });

  try {
    await client.connect();
    console.log('✅ Connecté à la base de données');

    const hashedPassword = await bcrypt.hash("admin123", 10);

    const result = await client.query(`
      INSERT INTO "User" (id, email, password, name, role, phone, "createdAt", "updatedAt")
      VALUES (gen_random_uuid(), $1, $2, $3, $4, $5, NOW(), NOW())
      ON CONFLICT (email)
      DO UPDATE SET password = $2, role = $4
      RETURNING id, email, role;
    `, ['admin@pickndream.fr', hashedPassword, 'Administrateur PicknDream', 'ADMIN', '+33612345678']);

    console.log('✅ Compte admin créé avec succès !');
    console.log('📧 Email: admin@pickndream.fr');
    console.log('🔑 Mot de passe: admin123');
    console.log('👑 Rôle: ADMIN');
    console.log('🆔 ID:', result.rows[0].id);

  } catch (error) {
    console.error('❌ Erreur:', error.message);
  } finally {
    await client.end();
  }
}

createAdmin();
