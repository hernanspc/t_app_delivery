import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/providers/users_providers.dart';
import 'package:flutter/material.dart';

class LoginController {
  final UsersProvider usersProvider = UsersProvider();

  bool isLoading = false;

  Future<ResponseApi?> login({
    required String email,
    required String password,
  }) async {
    // if (!_isValidEmail(email)) {
    //   return ResponseApi(success: false, message: "El email no es válido");
    // }

    try {
      isLoading = true;

      ResponseApi response = await usersProvider.login(email, password);
      print('🟨 usersProvider.login ${response?.toJson()}');

      return response;
    } catch (e) {
      return ResponseApi(success: false, message: "Ocurrió un error: $e");
    } finally {
      isLoading = false;
    }
  }

  bool _isValidEmail(String email) {
    return email.contains("@") && email.contains(".");
  }
}
