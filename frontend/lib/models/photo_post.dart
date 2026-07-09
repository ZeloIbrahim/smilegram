class PhotoPost {
  final int id;
  final String photoPath;
  final String datePublication;
  final String createdAt;
  final String username;
  final String? photoProfil;  // pas obliger d'avoir une pp
  final int likesCount;
  final int commentsCount;
  final bool aLike;

  PhotoPost({
    required this.id,
    required this.photoPath,
    required this.datePublication,
    required this.createdAt,
    required this.username,
    this.photoProfil,
    required this.likesCount,
    required this.commentsCount,
    required this.aLike,
  });

  factory PhotoPost.fromJson(Map<String, dynamic> json) {
    return PhotoPost(
      id: json["id"] as int,
      photoPath: json["photo_path"] as String,
      datePublication: json["date_publication"] as String,
      createdAt: json["created_at"] as String,
      username: json["username"] as String,
      photoProfil: json["photo_profil"] as String?,
      likesCount: json["likes_count"] as int? ?? 0,
      commentsCount: json["comments_count"] as int? ?? 0,
      aLike: json["a_like"] == 1 || json["a_like"] == true,
    );
  }
}