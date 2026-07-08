// Il faudrait avoir "un videur de securite" d'apres gmini il faut verifier l'utilisateur si il possede un badge valide (le token )
// sinon -> erreur pour evite d'avoir une ususrpation d'ifentite et les attque par bruteforce

const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET || "smilegram_secret_dev";

function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ erreur: "Authentification requise" });
  }

  const token = authHeader.split(" ")[1];
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch (err) {
    return res.status(401).json({ erreur: "Token invalide" });
  }
}

module.exports = { authMiddleware, JWT_SECRET };
