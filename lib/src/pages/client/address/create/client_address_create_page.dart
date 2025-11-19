import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/components/common/custom_text_form_field.dart';
import 'package:delivery_app/src/pages/client/address/create/client_address_create_controller.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ClientAddressCreatePage extends StatelessWidget {
  ClientAddressCreateController con = Get.put(ClientAddressCreateController());

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
            _textNewCategory(),
            _iconBack(),
          ],
        ),
      ),
    );
  }

  Widget _iconBack() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _textNewCategory() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 15),
        alignment: Alignment.topCenter,
        child: const Column(
          children: [
            Icon(EvaIcons.pin, size: 80),
            Text(
              "Nueva Direccion",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ],
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
      height: MediaQuery.of(context).size.height * 0.50,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.25,
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
            _textFieldDirection(),
            const SizedBox(height: 10),
            _textFieldCalle(),
            const SizedBox(height: 10),
            _textFieldRefPoint(context),
            _buttonCreate(context),
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

  Widget _textFieldDirection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        controller: con.addressController,
        label: 'Direccion',
        keyboardType: TextInputType.text,
        prefixIcon: EvaIcons.navigation,
      ),
    );
  }

  Widget _textFieldCalle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        controller: con.neighborhoodController,
        label: 'Calle',
        keyboardType: TextInputType.text,
        prefixIcon: EvaIcons.navigation2,
      ),
    );
  }

  Widget _textFieldRefPoint(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        onTap: () => con.openGoogleMaps(context),
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        controller: con.refPointController,
        label: 'Referencia',
        keyboardType: TextInputType.text,
        prefixIcon: EvaIcons.mapOutline,
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: CustomFilledButton(
        text: 'Agregar Direccion',
        onPressed: () => con.createAddress(),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
