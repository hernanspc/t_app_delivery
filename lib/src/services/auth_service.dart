import 'dart:convert';
import 'package:delivery_app/src/models/login/user_company_info.dart';
import 'package:delivery_app/src/models/user_session/user_session.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  UserSession? _user;
  UserSession? get user => _user;

  bool get isLoggedIn => _user != null;

  static const String _userKey = "USER_SESSION_DATA";

  /// 🔥 Guarda la data del usuario después del login
  Future<void> saveUserSession(UserCompanyInfo user) async {
    final prefs = await SharedPreferences.getInstance();

    _user = UserSession.fromCompanyInfo(user);

    await prefs.setString(_userKey, jsonEncode(user.toJson()));

    notifyListeners();
  }

  /// 🔥 Cargar sesión al iniciar la app
  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_userKey);

    if (saved != null) {
      _user = UserSession.fromJson(jsonDecode(saved));
      notifyListeners();
    }
  }

  /// 🔥 Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);

    _user = null;
    notifyListeners();
  }

  Future<void> saveDeviceToken(String tokenDevice) async {}
}
