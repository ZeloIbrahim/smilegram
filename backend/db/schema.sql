CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    motdepasse TEXT NOT NULL,
    username TEXT NOT NULL UNIQUE,
    prenom TEXT NOT NULL,
    nom TEXT NOT NULL,
    photo_profil TEXT,
    points_total INTEGER NOT NULL,
    streak_actuel INTEGER NOT NULL,
    meilleur_streak INTEGER NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
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
