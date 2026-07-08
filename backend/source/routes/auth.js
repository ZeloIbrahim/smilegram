const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const db = require("../db");
const { JWT_SECRET } = require("../middleware/auth");

const router = express.Router();

router.post("/register", async (req, res) => {
  const { email, password, username, prenom, nom } = req.body;

  if (!email || !password || !username || !prenom || !nom) {
    return res.status(400).json({ erreur: "Tous les champs sont requis" });
  }

  const existant = db.prepare("SELECT id FROM users WHERE email = ? OR username = ?").get(email, username);
  if (existant) {
    return res.status(409).json({ erreur: "Email ou username deja utilise" });
  }

  const motdepasse = await bcrypt.hash(password, 10);

  const result = db.prepare(
    "INSERT INTO users (email, motdepasse, username, prenom, nom) VALUES (?, ?, ?, ?, ?)"
  ).run(email, motdepasse, username, prenom, nom);

  const token = jwt.sign({ id: result.lastInsertRowid, username }, JWT_SECRET, { expiresIn: "7d" });
  res.status(201).json({ token });
});

router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ erreur: "Email et mot de passe requis" });
  }

  const user = db.prepare("SELECT * FROM users WHERE email = ?").get(email);
  if (!user) {
    return res.status(401).json({ erreur: "Email ou mot de passe incorrect" });
  }

  const motDePasseValide = await bcrypt.compare(password, user.motdepasse);
  if (!motDePasseValide) {
    return res.status(401).json({ erreur: "Email ou mot de passe incorrect" });
  }

  const token = jwt.sign({ id: user.id, username: user.username }, JWT_SECRET, { expiresIn: "7d" });
  res.json({ token });
});

module.exports = router;
