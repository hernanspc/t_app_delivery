import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/pages/client/profile/update/client_profile_update_controller.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../components/common/custom_text_form_field.dart';

class ClientProfileUpdatePage extends StatelessWidget {
  ClientProfileUpdateController con = Get.put(ClientProfileUpdateController());
  User user = User.fromJson(GetStorage().read('user'));

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
          child: GetBuilder<ClientProfileUpdateController>(
            builder: (value) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: con.imageFile != null
                        ? FileImage(con.imageFile!)
                        : con.userSession.image != null
                        ? NetworkImage(con.userSession.image!)
                        : const AssetImage('assets/img/profile-pic.png')
                              as ImageProvider,
                    radius: 60,
                    backgroundColor: Colors.white,
                  ),
                  if (con.imageFile == null && con.userSession.image == null)
                    CircularProgressIndicator(), // Indicador de carga
                ],
              );
            },
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
      height: MediaQuery.of(context).size.height * 0.45,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.30,
        left: 50,
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
            _textFieldName(),
            const SizedBox(height: 10),
            _textFieldLastName(),
            const SizedBox(height: 10),
            _textFieldPhone(),
            _buttonUpdate(context),
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

  Widget _buttonUpdate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: CustomFilledButton(
        text: 'Actualizar',
        onPressed: () => con.updateInfo(context),
      ),
    );
  }
}
