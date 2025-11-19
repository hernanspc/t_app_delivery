import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/components/common/custom_text_form_field.dart';
import 'package:delivery_app/src/pages/register/register_controller.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  RegisterController con = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _imageUser(context),
            _buttonBack(),
          ],
        ),
      ),
    );
  }

  Widget _buttonBack() {
    return SafeArea(
      child: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _imageUser(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            con.showAlertDialog(context);
          },
          child: GetBuilder<RegisterController>(
            builder: (value) => CircleAvatar(
              backgroundImage: con.imageFile != null
                  ? FileImage(con.imageFile!)
                  : const AssetImage('assets/img/profile-pic.png')
                        as ImageProvider,
              radius: 60,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.amber,
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.30,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 239, 239, 239),
        borderRadius: BorderRadius.circular(20),
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
            _textFieldName(),
            const SizedBox(height: 10),
            _textFieldLastName(),
            const SizedBox(height: 10),
            _textFieldPhone(),
            const SizedBox(height: 10),
            _textFieldPassword(),
            const SizedBox(height: 10),
            _textFieldPasswordRepeat(),
            _buttonRegister(context),
          ],
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 30),
      child: const Text(
        "Ingresa tu información",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        controller: con.emailController,
        label: 'Correo electronico',
        keyboardType: TextInputType.emailAddress,
        prefixIcon: EvaIcons.emailOutline,
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        controller: con.nameController,
        label: 'Nombre',
        keyboardType: TextInputType.text,
        prefixIcon: EvaIcons.person,
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        controller: con.lastnameController,
        label: 'Apellido',
        keyboardType: TextInputType.text,
        prefixIcon: EvaIcons.personOutline,
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        controller: con.phoneController,
        label: 'Telefono',
        keyboardType: TextInputType.phone,
        prefixIcon: EvaIcons.phone,
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        obscureText: true,
        controller: con.passwordController,
        label: 'Contraseña',
        keyboardType: TextInputType.text,
        prefixIcon: EvaIcons.lock,
      ),
    );
  }

  Widget _textFieldPasswordRepeat() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        obscureText: true,
        controller: con.confirmPasswordController,
        label: 'Confirma contraseña',
        keyboardType: TextInputType.text,
        prefixIcon: EvaIcons.lockOutline,
      ),
    );
  }

  Widget _buttonRegister(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: CustomFilledButton(
        text: 'Registrarse',
        onPressed: () => con.register(context),
      ),
    );
  }
}
