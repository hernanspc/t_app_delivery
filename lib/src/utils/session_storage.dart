import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const _jwtKey = 'jwt_token';
  static const _rememberMeKey = 'remember_me';

  /// Guarda el token JWT
  static Future<void> saveSessionJwt(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtKey, token);
  }

  /// Obtiene el token JWT
  static Future<String?> getSessionJwt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jwtKey);
  }

  /// Elimina el token (por ejemplo, al cerrar sesión)
  static Future<void> removeSessionJwt() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jwtKey);
  }

  //===================================================
  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  static Future<void> deleteRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
  }

  //=====================================================
  // Limpia solo datos de sesión (JWT + remember flag)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jwtKey);
    await prefs.remove(_rememberMeKey);
    // Si tienes refresh token u otros keys de sesión, quítalos aquí también.
  }
}
