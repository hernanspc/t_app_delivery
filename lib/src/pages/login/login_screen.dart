import 'dart:convert';

import 'package:delivery_app/src/pages/login/controller/login_controller.dart';
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
      _showCustomModal(
        title: "Mensaje",
        message: response.message ?? "Acceso correcto",
        type: response.type,
      );
      //   context.go("/rol_screen");
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

  void _showCustomModal({
    required String title,
    required String message,
    required String type,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CustomCupertinoModal(
        title: title,
        message: message,
        type: parseModalType(type),
      ),
    );
  }
}

enum CustomModalType { INFORMATIVO, ERROR, ADVERTENCIA }

CustomModalType parseModalType(String? value) {
  if (value == null) return CustomModalType.INFORMATIVO;

  switch (value.toUpperCase()) {
    case "ERROR":
      return CustomModalType.ERROR;
    case "ADVERTENCIA":
      return CustomModalType.ADVERTENCIA;
    case "INFORMATIVO":
      return CustomModalType.INFORMATIVO;
    default:
      return CustomModalType.INFORMATIVO;
  }
}

class CustomCupertinoModal extends StatelessWidget {
  final String title;
  final String message;
  final CustomModalType type;

  const CustomCupertinoModal({
    super.key,
    required this.title,
    required this.message,
    this.type = CustomModalType.INFORMATIVO,
  });

  Color _getColor() {
    switch (type) {
      case CustomModalType.INFORMATIVO:
        return Colors.green;
      case CustomModalType.ERROR:
        return Colors.red;
      case CustomModalType.ADVERTENCIA:
        return Colors.amber;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case CustomModalType.INFORMATIVO:
        return CupertinoIcons.checkmark_circle_fill;
      case CustomModalType.ERROR:
        return CupertinoIcons.xmark_circle_fill;
      case CustomModalType.ADVERTENCIA:
        return CupertinoIcons.exclamationmark_triangle_fill;
      default:
        return CupertinoIcons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), color: _getColor(), size: 45),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _getColor(),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text("Aceptar"),
        ),
      ],
    );
  }
}
