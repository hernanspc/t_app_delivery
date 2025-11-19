import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/components/common/custom_text_form_field.dart';
import 'package:delivery_app/src/pages/login/login_controller.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginController con = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SizedBox(height: 50, child: _textDontHaveAccount()),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      color: Colors.amber,
    );
  }

  Widget _textAppName() {
    return const Text(
      "Delivero",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "¿No tienes cuenta?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 7),
        GestureDetector(
          onTap: () => con.goToRegisterPage(),
          child: Text(
            "Registrate aquí",
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.33,
        left: 30,
        right: 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 239, 239, 239),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15,
            offset: Offset(0, 0.75),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldEmail(),
            const SizedBox(height: 10),
            _textFieldPassword(),
            _buttonLogin(),
          ],
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return Obx(
      () => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: CustomFilledButton(
          text: con.isLoading.value ? 'Cargando...' : 'Iniciar Sesión',
          onPressed: () => con.login(),
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: CustomTextFormField(
        controller: con.emailController,
        label: 'Correo electronico',
        keyboardType: TextInputType.emailAddress,
        prefixIcon: EvaIcons.emailOutline,
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: CustomTextFormField(
        controller: con.passwordController,
        label: 'Contraseña',
        keyboardType: TextInputType.text,
        prefixIcon: EvaIcons.lockOutline,
        obscureText: true,
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 40),
      child: const Text(
        "Ingresa tu información",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _imageCover() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 15),
        alignment: Alignment.center,
        child: Image.asset('assets/img/delivery.png', width: 130, height: 130),
      ),
    );
  }
}
