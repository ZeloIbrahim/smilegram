class Comment {
  final int id;
  final String texte;
  final String createdAt;
  final String username;

  Comment({
    required this.id,
    required this.texte,
    required this.createdAt,
    required this.username,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"] as int,
      texte: json["texte"] as String,
      createdAt: json["created_at"] as String,
      username: json["username"] as String,
    );
  }
}
