import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:delivery_app/src/pages/login/controller/login_controller.dart';
import 'package:delivery_app/src/utils/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/src/models/login/user_company_info.dart';
import 'package:delivery_app/src/utils/functions.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService with ChangeNotifier {
  UserCompanyInfo? userSession;
  String? _jwt;

  // ----------------------------
  // GETTERS
  // ----------------------------
  UserCompanyInfo? get userInfoSession => userSession;
  String? get token => _jwt;
  bool get isLoggedIn => userSession != null && _jwt != null;
  final LoginController _loginController = LoginController();

  // ----------------------------
  // Guardar sesión (solo memoria)
  // ----------------------------
  Future<void> saveUserSession(
    UserCompanyInfo userInfo,
    String usuario,
    String clave,
  ) async {
    userSession = userInfo;
    final tokenGenerated = await generateLocalJwt(
      usuario: usuario,
      clave: clave,
    );
    print('🌟 JWT Token generado: $tokenGenerated');
    await SessionStorage.saveSessionJwt(tokenGenerated);
    notifyListeners();
  }

  // ----------------------------
  // Validar sesión
  // ----------------------------
  Future<bool> checkSession() async {
    final token = await SessionStorage.getSessionJwt();
    print('⭐️ isLoggedIn token: $token');

    if (token == null || token.isEmpty) {
      print('token es null o vacío');
      await SessionStorage.removeSessionJwt();
      return false;
    }

    if (!JwtDecoder.isExpired(token)) {
      final decoded = JwtDecoder.decode(token);
      print('✅ Token válido: $decoded  ${userSession?.toJson()}');
      return true;
    } else {
      print('❌ Token expirado');
      await SessionStorage.removeSessionJwt();
      return false;
    }
  }

  // ----------------------------
  // Cargar usuario (solo memoria)
  // ----------------------------
  Future<void> getCurrentUser() async {
    final token = await SessionStorage.getSessionJwt();
    if (token == null || token.isEmpty) return;

    final Map<String, dynamic> decoded = JwtDecoder.decode(token);

    final response = await _loginController.login(
      email: decoded['usuario'],
      password: decoded['clave'],
    );
    print("🟩 AuthService.getCurrentUser: ${response.toJson()}");
    userSession = response.data.first;

    saveUserSession(userSession!, decoded['usuario'], decoded['clave']);
  }

  // ----------------------------
  // Logout
  // ----------------------------
  void logout() {
    userSession = null;
    _jwt = null;
    notifyListeners();
    print('🔴 Sesión cerrada');
  }

  // ----------------------------
  // Validar expiración del token
  // ----------------------------
  bool get isTokenExpired {
    if (_jwt == null) return true;
    try {
      JWT.verify(_jwt!, SecretKey('clave_secreta_local'));
      return false;
    } catch (_) {
      return true;
    }
  }

  // ----------------------------
  // Token dispositivo (vacío)
  // ----------------------------
  Future<void> saveDeviceToken(String tokenDevice) async {
    print('🔔 saveDeviceToken llamado: $tokenDevice');
  }
}
