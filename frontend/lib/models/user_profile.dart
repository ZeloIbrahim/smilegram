class UserProfile {
  final int id;
  final String email;
  final String username;
  final String prenom;
  final String nom;
  final String? photoProfil; // pas obliger d'avoir une pp
  final int pointsTotal;
  final int streakActuel;
  final int meilleurStreak;

  UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.prenom,
    required this.nom,
    this.photoProfil,
    required this.pointsTotal,
    required this.streakActuel,
    required this.meilleurStreak,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json["id"] as int,
      email: json["email"] as String,
      username: json["username"] as String,
      prenom: json["prenom"] as String,
      nom: json["nom"] as String,
      photoProfil: json["photo_profil"] as String?,
      pointsTotal: json["points_total"] as int,
      streakActuel: json["streak_actuel"] as int,
      meilleurStreak: json["meilleur_streak"] as int,
    );
  }
}
