import 'package:flutter/material.dart';
import 'package:delivery_app/src/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    // Carga la sesión desde SharedPreferences
    await authService.loadUserSession();

    // Verifica si hay sesión válida
    if (authService.isLoggedIn && !authService.isTokenExpired) {
      context.go('/client_home_screen');
    } else {
      authService.logout(); // Limpia cualquier sesión inválida
      context.go('/login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
