import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const emailKey = "email";
  static const tokenKey = "token";
  static const refreshTokenKey = "refreshToken";

  Future<void> storeEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(emailKey, email);
  }

  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> storeRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(refreshTokenKey, refreshToken);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  Future<List<String>> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(tokenKey) && prefs.containsKey(refreshTokenKey)) {
      final token = prefs.getString(tokenKey) ?? '';
      final refreshToken = prefs.getString(refreshTokenKey) ?? '';
      return [token, refreshToken];
    } else {
      return ['', ''];
    }
  }


  void removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
    prefs.remove(refreshTokenKey);
  }

  void removeEmail() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(emailKey);

  }
}
