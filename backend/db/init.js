// importation le fichier sql

const fs = require("fs");
const path = require("path");
const { DatabaseSync } = require("node:sqlite");
const { Db } = require("mongodb");

const DB_PATH = path.join(__dirname, "smilegram.sqlite");
const SCHEMA_PATH = path.join(__dirname, "schema.sql");

function main(){
    const db = new DatabaseSync(DB_PATH);
    const schema = fs.readFileSync(SCHEMA_PATH, "utf-8"); // lit le contenu sql
    db.exec(schema);
    console.log(`Base intialisee : ${DB_PATH}`);
    db.close;
}

main();