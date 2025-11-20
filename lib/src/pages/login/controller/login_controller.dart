import 'dart:convert';

import 'package:delivery_app/src/models/login/login_response.dart';
import 'package:delivery_app/src/providers/users_providers.dart';

class LoginController {
  final UsersProvider usersProvider = UsersProvider();

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await usersProvider.login(email, password);

    print(
      "🟨 usersProvider.login:\n${const JsonEncoder.withIndent('  ').convert(response.toJson())}",
    );

    return response;
  }
}
