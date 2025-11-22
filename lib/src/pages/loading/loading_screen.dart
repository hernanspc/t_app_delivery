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

    final autenticado = await authService.checkSession();
    print('autenticado $autenticado');

    if (autenticado) {
      await authService.getCurrentUser(); // ⚡ aquí se hace "login" en memoria
      context.go('/client_home_screen');
    } else {
      authService.logout();
      context.go('/login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
