const sql = require('mssql');

const config = {
    user: 'SA',
    password: 'reallyStrongPwd123',
    server: 'localhost',
    port: 1433,
    database: 'DatabaseTermProject',
    options: {
        encrypt: true,
        trustServerCertificate: true,
    },
};

const connectToDatabase = async () => {
    try {
        const pool = await sql.connect(config);
        console.log('Database connected successfully!');
        return pool;
    } catch (err) {
        console.error('Database connection failed:', err);
        throw err;
    }
};

module.exports = connectToDatabase;
