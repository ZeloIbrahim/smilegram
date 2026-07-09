// le token et le preference du theme 

import "package:shared_preferences/shared_preferences.dart";

class AuthStorage {
  static const _tokenKey = "smilegram_token";
  static const _darkModeKey = "smilegram_dark_mode";

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  static Future<void> setDarkMode(bool actif) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, actif);
  }
}
