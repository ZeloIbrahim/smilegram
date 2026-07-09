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
           users.username, users.photo_profil,
           (SELECT COUNT(*) FROM likes WHERE likes.photo_id = photos.id) AS likes_count,
           (SELECT COUNT(*) FROM comments WHERE comments.photo_id = photos.id) AS comments_count,
           (SELECT COUNT(*) FROM likes WHERE likes.photo_id = photos.id AND likes.user_id = ?) AS a_like
    FROM photos
    JOIN users ON users.id = photos.user_id
    ORDER BY photos.created_at DESC
    LIMIT 30
  `).all(req.user.id);

  res.json({ photos });
});


router.post("/:id/like", authMiddleware, (req, res) => {
  const userId = req.user.id;
  const photoId = req.params.id;
 
  const photo = db.prepare("SELECT id FROM photos WHERE id = ?").get(photoId);
  if (!photo) return res.status(404).json({ erreur: "Photo introuvable" });
 
  const dejaLike = db.prepare(
    "SELECT id FROM likes WHERE user_id = ? AND photo_id = ?"
  ).get(userId, photoId);
 
  if (dejaLike) {
    db.prepare("DELETE FROM likes WHERE id = ?").run(dejaLike.id);
  } else {
    db.prepare("INSERT INTO likes (user_id, photo_id) VALUES (?, ?)").run(userId, photoId);
  }
 
  const { count } = db.prepare(
    "SELECT COUNT(*) AS count FROM likes WHERE photo_id = ?"
  ).get(photoId);
 
  res.json({ likes_count: count, a_like: !dejaLike });
});
 
router.get("/:id/comments", authMiddleware, (req, res) => {
  const photo = db.prepare("SELECT id FROM photos WHERE id = ?").get(req.params.id);
  if (!photo) return res.status(404).json({ erreur: "Photo introuvable" });
 
  const comments = db.prepare(`
    SELECT comments.id, comments.texte, comments.created_at, users.username
    FROM comments
    JOIN users ON users.id = comments.user_id
    WHERE comments.photo_id = ?
    ORDER BY comments.created_at ASC
  `).all(req.params.id);
 
  res.json({ comments });
});
 
router.post("/:id/comments", authMiddleware, (req, res) => {
  const { texte } = req.body;
  if (!texte || !texte.trim()) {
    return res.status(400).json({ erreur: "Le commentaire ne peut pas etre vide" });
  }
 
  const photo = db.prepare("SELECT id FROM photos WHERE id = ?").get(req.params.id);
  if (!photo) return res.status(404).json({ erreur: "Photo introuvable" });
 
  const result = db.prepare(
    "INSERT INTO comments (user_id, photo_id, texte) VALUES (?, ?, ?)"
  ).run(req.user.id, req.params.id, texte.trim());
 
  const comment = db.prepare(`
    SELECT comments.id, comments.texte, comments.created_at, users.username
    FROM comments JOIN users ON users.id = comments.user_id
    WHERE comments.id = ?
  `).get(result.lastInsertRowid);
 
  res.status(201).json(comment);
});

module.exports = router;
