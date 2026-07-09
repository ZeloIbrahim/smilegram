CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    motdepasse TEXT NOT NULL,
    username TEXT NOT NULL UNIQUE,
    prenom TEXT NOT NULL,
    nom TEXT NOT NULL,
    photo_profil TEXT,
    points_total INTEGER NOT NULL DEFAULT 0,
    streak_actuel INTEGER NOT NULL DEFAULT 0,
    meilleur_streak INTEGER NOT NULL DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS photos (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    photo_path TEXT NOT NULL,
    date_publication TEXT NOT NULL,
    points_gagnes INTEGER NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id,date_publication) -- empeche d'avoir plusieurs photos dans la mm journée

);

CREATE INDEX IF NOT EXISTS idx_photos_date on photos(date_publication);


-- partie 2 du backend finalement je compte ajouter les likes+comments

CREATE TABLE IF NOT EXISTS likes (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id     INTEGER NOT NULL REFERENCES users(id),
  photo_id    INTEGER NOT NULL REFERENCES photos(id),
  created_at  TEXT DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, photo_id)   -- empeche de liker deux fois la meme photo
);
 
CREATE TABLE IF NOT EXISTS comments (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id     INTEGER NOT NULL REFERENCES users(id),
  photo_id    INTEGER NOT NULL REFERENCES photos(id),
  texte       TEXT NOT NULL,
  created_at  TEXT DEFAULT CURRENT_TIMESTAMP
);
 
CREATE INDEX IF NOT EXISTS idx_likes_photo ON likes(photo_id);
CREATE INDEX IF NOT EXISTS idx_comments_photo ON comments(photo_id);