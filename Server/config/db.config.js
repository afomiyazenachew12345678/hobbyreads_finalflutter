const dotenv = require("dotenv");
dotenv.config();

module.exports = {
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root", 
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "hobbyreads_db",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

console.log("Database config:", process.env.DB_NAME);
