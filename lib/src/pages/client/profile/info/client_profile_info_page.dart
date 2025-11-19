import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientProfileInfoPage extends StatelessWidget {
  ClientProfileInfoController con = Get.put(ClientProfileInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Obx(
          () => Stack(
            children: [
              _backgroundCover(context),
              _boxForm(context),
              _imageUser(context),
              Column(children: [_buttonSignOut(), _goToRoles()]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageUser(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        alignment: Alignment.topCenter,
        child: CircleAvatar(
          backgroundImage: con.user.value.image != null
              ? NetworkImage(con.user.value.image!)
              : const AssetImage('assets/img/profile-pic.png') as ImageProvider,
          radius: 60,
          backgroundColor: Colors.white,
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
            // _textYourInfo(),
            _textName(),
            _textEmail(),
            _textPhone(),
            _buttonUpdated(context),
          ],
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 30),
      child: const Text(
        "Actualiza tu información",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buttonUpdated(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: CustomFilledButton(
        text: 'Actualizar Datos',
        onPressed: () => con.goToProfileUpdate(),
      ),
    );
  }

  Widget _textName() {
    String fullName = con.user != null
        ? "${con.user.value.name} ${con.user.value.lastname}"
        : "Nombre Apellido";

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ListTile(
        leading: const Icon(EvaIcons.person),
        title: const Text("Nombre"),
        subtitle: Text(fullName, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _textEmail() {
    return ListTile(
      leading: const Icon(EvaIcons.email),
      title: const Text("Email"),
      subtitle: Text(con.user.value.email ?? ''),
    );
  }

  Widget _textPhone() {
    return ListTile(
      leading: const Icon(EvaIcons.phone),
      title: const Text("Telefono"),
      subtitle: Text(con.user.value.phone ?? ''),
    );
  }

  Widget _buttonSignOut() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () => con.signOut(),
          icon: const Icon(EvaIcons.power, color: Colors.white, size: 25),
        ),
      ),
    );
  }

  Widget _goToRoles() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => con.goToRoles(),
        icon: const Icon(EvaIcons.person, color: Colors.white, size: 25),
      ),
    );
  }
}
