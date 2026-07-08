const POINTS_BASE = 10;

// Renvoie la date d aujourd hui 
function dateDuJour() {
  return new Date().toISOString().split("T")[0];
}

// Renvoie la date d hier 
function dateDHier() {
  const hier = new Date();
  hier.setDate(hier.getDate() - 1);
  return hier.toISOString().split("T")[0];
}

function calculerNouveauStreak(aPosteHier, streakActuel) {
  return aPosteHier ? streakActuel + 1 : 1;
}

function calculerPoints(nouveauStreak) {
  return POINTS_BASE + nouveauStreak;
}

module.exports = { dateDuJour, dateDHier, calculerNouveauStreak, calculerPoints };
