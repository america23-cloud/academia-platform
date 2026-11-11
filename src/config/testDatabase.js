
require('dotenv').config();

const pool = require('./database');

async function testConnection() {
  try {
    const result = await pool.query(`
      SELECT
        current_database() AS database,
        current_user AS username,
        NOW() AS server_time
    `);

    console.log('Conexión a PostgreSQL exitosa');
    console.table(result.rows);
  } catch (error) {
    console.error('Error al conectar con PostgreSQL:', error.message);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
}

testConnection();
