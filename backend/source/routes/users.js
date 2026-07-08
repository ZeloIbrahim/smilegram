const express = require("express");
const db = require("../db");
const { authMiddleware } = require("../middleware/auth");
const upload = require("../upload");

const router = express.Router();

const CHAMPS_PUBLICS = "id, email, username, prenom, nom, photo_profil, points_total, streak_actuel, meilleur_streak";

router.get("/me", authMiddleware, (req, res) => {
  const user = db.prepare(`SELECT ${CHAMPS_PUBLICS} FROM users WHERE id = ?`).get(req.user.id);
  if (!user) return res.status(404).json({ erreur: "Utilisateur introuvable" });
  res.json(user);
});

router.put("/me", authMiddleware, upload.single("photo_profil"), (req, res) => {
  const { username, prenom, nom } = req.body;
  const userId = req.user.id;

  const user = db.prepare("SELECT * FROM users WHERE id = ?").get(userId);
  if (!user) return res.status(404).json({ erreur: "Utilisateur introuvable" });

  const nouveauUsername = username || user.username;
  const nouveauPrenom = prenom || user.prenom;
  const nouveauNom = nom || user.nom;
  const nouvellePhoto = req.file ? req.file.filename : user.photo_profil;

  db.prepare(
    "UPDATE users SET username = ?, prenom = ?, nom = ?, photo_profil = ? WHERE id = ?"
  ).run(nouveauUsername, nouveauPrenom, nouveauNom, nouvellePhoto, userId);

  const userMisAJour = db.prepare(`SELECT ${CHAMPS_PUBLICS} FROM users WHERE id = ?`).get(userId);
  res.json(userMisAJour);
});

module.exports = router;
