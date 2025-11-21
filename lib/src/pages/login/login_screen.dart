import 'dart:convert';

import 'package:delivery_app/src/pages/login/controller/login_controller.dart';
import 'package:delivery_app/src/widgets/custom_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/components/common/custom_text_form_field.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late LoginController controller;

  bool isLoading = false;

  Future<void> handleLogin() async {
    FocusScope.of(context).unfocus();

    setState(() => isLoading = true);

    final response = await controller.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    print(
      "🤖 handleLogin:\n${const JsonEncoder.withIndent('  ').convert(response.toJson())}",
    );

    if (response.success == true) {
      await _showCustomModal(
        title: "Mensaje",
        message: response.message ?? "Acceso correcto",
        type: response.type,
        barrierDismissible: true,
      );

      // ➜ recién después de cerrar el modal
      if (mounted) {
        context.go("/client_home_screen");
      }
      return;
    }

    _showCustomModal(
      title: "Mensaje",
      message: response.message ?? "Ocurrió un error",
      type: response.type,
    );
  }

  void goToRegister() {
    // Navigator.pushNamed(context, '/register');
    print("Ir a registro");
  }

  @override
  void initState() {
    super.initState();
    controller = LoginController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SizedBox(height: 50, child: _textDontHaveAccount()),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            _backgroundCover(context),
            _boxForm(context),
            Column(children: [_imageCover(), _textAppName()]),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber, Color(0xFFFFC107)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _imageCover() {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20, bottom: 10),
        child: Image.asset('assets/img/delivery.png', width: 130, height: 130),
      ),
    );
  }

  Widget _textAppName() {
    return const Text(
      "Delivero",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.47,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.33,
        left: 30,
        right: 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: [
            _titleForm(),
            _textFieldEmail(),
            const SizedBox(height: 10),
            _textFieldPassword(),
            _buttonLogin(),
          ],
        ),
      ),
    );
  }

  Widget _titleForm() {
    return const Text(
      "Ingresa tu información",
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: CustomTextFormField(
        controller: emailController,
        label: 'Usuario',
        keyboardType: TextInputType.emailAddress,
        prefixIcon: EvaIcons.person,
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: CustomTextFormField(
        controller: passwordController,
        label: 'Contraseña',
        obscureText: true,
        prefixIcon: EvaIcons.lockOutline,
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
      child: CustomFilledButton(
        text: isLoading ? 'Cargando...' : 'Iniciar Sesión',
        onPressed: isLoading ? null : handleLogin,
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "¿No tienes cuenta?",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: goToRegister,
          child: const Text(
            "Regístrate aquí",
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCustomModal({
    required String title,
    required String message,
    required String? type,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible:
          barrierDismissible, // 👈 Permite cerrar haciendo tap afuera
      builder: (_) => CustomCupertinoModal(
        title: title,
        message: message,
        type: parseModalType(type),
      ),
    );
  }
}
