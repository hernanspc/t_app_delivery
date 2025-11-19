import 'package:delivery_app/src/models/rol.dart';
import 'package:delivery_app/src/pages/roles/roles_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RolesPage extends StatelessWidget {
  RolesController con = Get.put(RolesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Selecciona el rol",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.12,
        ),
        child: ListView(
          children: con.user.roles != null
              ? con.user.roles!.map((Rol rol) {
                  return _cardRol(rol);
                }).toList()
              : [],
        ),
      ),
    );
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector(
      onTap: () => con.goToPageRol(rol),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15, top: 15),
            height: 100,
            child: FadeInImage(
              placeholder: const AssetImage('assets/img/jar-loading.gif'),
              fit: BoxFit.contain,
              image: NetworkImage(rol.image!),
              fadeInDuration: const Duration(milliseconds: 50),
            ),
          ),
          Text(
            rol.name ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
