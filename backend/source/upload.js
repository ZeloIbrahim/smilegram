const multer = require("multer");
const path = require("path");

const UPLOADS_DIR = path.join(__dirname, "..", "uploads");

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, UPLOADS_DIR),
  filename: (req, file, cb) => {
    const extension = path.extname(file.originalname) || ".jpg";
    const nomFichier = `${Date.now()}_${Math.round(Math.random() * 1e9)}${extension}`;
    cb(null, nomFichier);
  },
});

function filtreImage(req, file, cb) {
  if (!file.mimetype.startsWith("image/")) {
    return cb(new Error("Seules les images sont acceptees"));
  }
  cb(null, true);
}

const upload = multer({
  storage,
  fileFilter: filtreImage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5 Mo max (meme si on s'en fiche un peu car ce site est la pour mon apprentissage)
});

module.exports = upload;