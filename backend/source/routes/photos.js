const express = require("express");
const fs = require("fs");
const db = require("../db");
const { authMiddleware } = require("../middleware/auth");
const upload = require("../upload");
const { dateDuJour, dateDHier, calculerNouveauStreak, calculerPoints } = require("../utils/streak");

const router = express.Router();

router.post("/", authMiddleware, upload.single("photo"), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ erreur: "Photo manquante" });
  }

  const userId = req.user.id;
  const aujourdHui = dateDuJour();

  const dejaPostee = db.prepare(
    "SELECT id FROM photos WHERE user_id = ? AND date_publication = ?"
  ).get(userId, aujourdHui);

  if (dejaPostee) {
    fs.unlink(req.file.path, () => {}); // on supprime le fichier inutile
    return res.status(409).json({ erreur: "Tu as deja poste ta photo du jour" });
  }

  const user = db.prepare("SELECT * FROM users WHERE id = ?").get(userId);

  const photoHier = db.prepare(
    "SELECT id FROM photos WHERE user_id = ? AND date_publication = ?"
  ).get(userId, dateDHier());

  const nouveauStreak = calculerNouveauStreak(Boolean(photoHier), user.streak_actuel);
  const points = calculerPoints(nouveauStreak);
  const nouveauRecord = Math.max(user.meilleur_streak, nouveauStreak);

  db.prepare(
    "INSERT INTO photos (user_id, photo_path, date_publication, points_gagnes) VALUES (?, ?, ?, ?)"
  ).run(userId, req.file.filename, aujourdHui, points);

  db.prepare(
    "UPDATE users SET points_total = points_total + ?, streak_actuel = ?, meilleur_streak = ? WHERE id = ?"
  ).run(points, nouveauStreak, nouveauRecord, userId);

  res.status(201).json({
    message: "Photo postee",
    streak_actuel: nouveauStreak,
    meilleur_streak: nouveauRecord,
    points_gagnes: points,
    points_total: user.points_total + points,
  });
});

router.get("/feed", authMiddleware, (req, res) => {
  const photos = db.prepare(`
    SELECT photos.id, photos.photo_path, photos.date_publication, photos.created_at,
           users.username, users.photo_profil
    FROM photos
    JOIN users ON users.id = photos.user_id
    ORDER BY photos.created_at DESC
    LIMIT 30
  `).all();

  res.json({ photos });
});

module.exports = router;
