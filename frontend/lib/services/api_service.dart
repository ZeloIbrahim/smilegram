// tous les appels de backedn

import "dart:convert";
import "package:http/http.dart" as http;
import "../models/user_profile.dart";
import "../models/photo_post.dart";
import "auth_storage.dart";
import "../models/comment.dart";
import "package:http_parser/http_parser.dart"; // sinon erreur d'upload dans l'api

class ApiService {
  static const String baseUrl = "http://localhost:3001";

  Future<Map<String, String>> _headersAvecToken() async {
    final token = await AuthStorage.getToken();
    return {"Authorization": "Bearer $token"};
  }

  Future<String> register({
    required String email,
    required String password,
    required String username,
    required String prenom,
    required String nom,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "username": username,
        "prenom": prenom,
        "nom": nom,
      }),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201) {
      throw Exception(data["erreur"] ?? "Erreur lors de l'inscription");
    }
    return data["token"] as String;
  }

  Future<String> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(data["erreur"] ?? "Erreur de connexion");
    }
    return data["token"] as String;
  }

  Future<UserProfile> getProfil() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/users/me"),
      headers: await _headersAvecToken(),
    );
    if (response.statusCode != 200) {
      throw Exception("Impossible de charger le profil");
    }
    return UserProfile.fromJson(jsonDecode(response.body));
  }

  Future<List<PhotoPost>> getFeed() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/photos/feed"),
      headers: await _headersAvecToken(),
    );
    if (response.statusCode != 200) {
      throw Exception("Impossible de charger le fil");
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> photos = data["photos"];
    return photos.map((p) => PhotoPost.fromJson(p as Map<String, dynamic>)).toList();
  }

  MediaType _detecterMediaType(String filename) {
  final extension = filename.toLowerCase().split('.').last;
  switch (extension) {
    case "png":
      return MediaType("image", "png");
    case "jpg":
    case "jpeg":
      return MediaType("image", "jpeg");
    case "webp":
      return MediaType("image", "webp");
    default:
      return MediaType("image", "jpeg");
  }
}

  Future<Map<String, dynamic>> postPhoto({
    required List<int> photoBytes,
    required String filename,
  }) async {
    final token = await AuthStorage.getToken();
    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/api/photos"));
    request.headers["Authorization"] = "Bearer $token";
    request.files.add(http.MultipartFile.fromBytes(
      "photo", photoBytes,
      filename: filename,
      contentType: _detecterMediaType(filename),
    ));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 201) {
      throw Exception(data["erreur"] ?? "Erreur lors de l'envoi");
    }
    return data;
  }

  Future<UserProfile> updateProfil({
    String? username,
    String? prenom,
    String? nom,
    List<int>? photoBytes,
    String? filename,
  }) async {
    final token = await AuthStorage.getToken();
    final request = http.MultipartRequest("PUT", Uri.parse("$baseUrl/api/users/me"));
    request.headers["Authorization"] = "Bearer $token";
    if (username != null) request.fields["username"] = username;
    if (prenom != null) request.fields["prenom"] = prenom;
    if (nom != null) request.fields["nom"] = nom;
    if (photoBytes != null && filename != null) {
      request.files.add(http.MultipartFile.fromBytes(
        "photo_profil", photoBytes,
        filename: filename,
        contentType: _detecterMediaType(filename),
      )); 
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise a jour du profil");
    }
    return UserProfile.fromJson(jsonDecode(response.body));
  }

   Future<Map<String, dynamic>> toggleLike(int photoId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/photos/$photoId/like"),
      headers: await _headersAvecToken(),
    );
    if (response.statusCode != 200) {
      throw Exception("Erreur lors du like");
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<Comment>> getComments(int photoId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/photos/$photoId/comments"),
      headers: await _headersAvecToken(),
    );
    if (response.statusCode != 200) {
      throw Exception("Impossible de charger les commentaires");
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> comments = data["comments"];
    return comments.map((c) => Comment.fromJson(c as Map<String, dynamic>)).toList();
  }

  Future<Comment> postComment(int photoId, String texte) async {
    final headers = await _headersAvecToken();
    headers["Content-Type"] = "application/json";
    final response = await http.post(
      Uri.parse("$baseUrl/api/photos/$photoId/comments"),
      headers: headers,
      body: jsonEncode({"texte": texte}),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201) {
      throw Exception(data["erreur"] ?? "Erreur lors de l'envoi du commentaire");
    }
    return Comment.fromJson(data);
  }

}
