import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:delivery_app/src/models/login/user_company_info.dart';
import 'package:delivery_app/src/models/user_session/user_session.dart';
import 'package:delivery_app/src/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  UserCompanyInfo? user;
  String? _jwt;

  UserCompanyInfo? get userInfoSession => user;
  String? get token => _jwt;

  bool get isLoggedIn => user != null && _jwt != null;

  static const _userKey = "USER_SESSION_DATA";
  static const _tokenKey = "JWT_TOKEN";

  Future<void> saveUserSession(UserCompanyInfo user) async {
    final prefs = await SharedPreferences.getInstance();

    user = user;
    _jwt = generateLocalJwt(userId: user.usuarioId);

    await prefs.setString(_userKey, jsonEncode(user!.toJson()));
    await prefs.setString(_tokenKey, _jwt!);

    notifyListeners();
  }

  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString(_userKey);
    final savedToken = prefs.getString(_tokenKey);

    if (savedUser != null && savedToken != null) {
      user = UserCompanyInfo.fromJson(jsonDecode(savedUser));
      _jwt = savedToken;
      notifyListeners();
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);

    user = null;
    _jwt = null;
    notifyListeners();
  }

  bool get isTokenExpired {
    if (_jwt == null) return true;
    try {
      final jwt = JWT.verify(_jwt!, SecretKey('clave_secreta_local'));
      return false; // válido
    } catch (e) {
      return true; // expirado o inválido
    }
  }

  Future<void> saveDeviceToken(String tokenDevice) async {}
}
