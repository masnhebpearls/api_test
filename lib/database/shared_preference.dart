import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_token/constants/constant_class.dart';

class SharedPreferenceHelper {

  ///store email using shared preference on [emailKey] key
  Future<void> storeEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ConstantClass.emailKey, email);
  }

  ///store access token using shared preference on [tokenKey] key
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ConstantClass.tokenKey, token);
  }

  ///store refresh token using shared preference on [refreshTokenKey] key
  Future<void> storeRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ConstantClass.refreshTokenKey, refreshToken);
  }

  ///retrieves email using shared preference stored on [emailKey] key
  ///return String value of email
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ConstantClass.emailKey);
  }

  ///retrieves tokens using shared preference stored on [tokenKey] and  [refreshTokenKey] key
  ///returns list of Strings which contains tokens with first index being access token
  Future<List<String>> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(ConstantClass.tokenKey) && prefs.containsKey(ConstantClass.refreshTokenKey)) {
      final token = prefs.getString(ConstantClass.tokenKey) ?? '';
      final refreshToken = prefs.getString(ConstantClass.refreshTokenKey) ?? '';
      return [token, refreshToken];
    } else {
      return ['', ''];
    }
  }

  ///removes the token from [tokenKey] and [refreshToken]
  void removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(ConstantClass.tokenKey);
    prefs.remove(ConstantClass.refreshTokenKey);
  }

  ///removes email stored on [emailKey]
  void removeEmail() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(ConstantClass.emailKey);

  }
}
