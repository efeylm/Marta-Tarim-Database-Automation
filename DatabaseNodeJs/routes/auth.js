const express = require('express');
const router = express.Router();
const sql = require('mssql');
const connectToDatabase = require('../db');

router.post('/login', async (req, res) => {
    const { FirstName, LastName, Password } = req.body;

    if (!FirstName || !LastName || !Password) {
        return res.status(400).json({ message: 'Username and password are required.' });
    }

    try {
        const db = await connectToDatabase();
        const result = await db.request()
            .input('FirstName', sql.VarChar, FirstName)
            .input('LastName', sql.VarChar, LastName)
            .input('Password', sql.VarChar, Password)
            .query(
                'SELECT FirstName, LastName, Password FROM Employee WHERE FirstName = @FirstName AND LastName = @LastName AND Password = @Password'
            );

        if (result.recordset.length > 0) {
            const user = result.recordset[0];
            res.json({ name: user.FirstName, surname: user.LastName });
        } else {
            res.status(401).json({ message: 'Invalid username or password.' });
        }
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ message: 'Internal server error.' });
    }
});

module.exports = router;
