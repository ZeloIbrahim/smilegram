// partager la connexion a la base de donnes avec tout le reste

const path = require("path");
const { DatabaseSync } = require("node:sqlite");

const DB_PATH = path.join(__dirname, "..", "db","smilegram.sqlite");
const db = new DatabaseSync(DB_PATH);

module.exports = db; 