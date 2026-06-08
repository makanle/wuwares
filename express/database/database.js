const mysql = require('mysql2/promise');

const db = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'wuwaresdb'
})

db.connect();
module.exports = db