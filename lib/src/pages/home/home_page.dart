import 'package:delivery_app/src/pages/home/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomeController con = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            con.signOut();
          },
          child: const Text("Cerrar sesion"),
        ),
      ),
    );
  }
}
