import 'package:delivery_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/providers/users_providers.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsersProvider usersProviders = UsersProvider();
  var isLoading = false.obs; // Observador para controlar el estado de carga

  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (isValidForm(email, password)) {
      try {
        isLoading.value = true; // Establecer isLoading a true al iniciar sesión
        ResponseApi responseApi = await usersProviders.login(email, password);
        if (responseApi.success == true) {
          GetStorage().write('user', responseApi.data);
          User myUser = User.fromJson(GetStorage().read('user'));
          if (myUser.roles!.length > 1) {
            goToRolesPage();
          } else {
            goToClientHomePage();
          }
        } else {
          Get.snackbar('Login Fallido', responseApi.message ?? '');
        }
      } finally {
        isLoading.value =
            false; // Establecer isLoading a false después de completar la solicitud
      }
    }
  }

  void goToHomePage() {
    Get.offNamedUntil('/home', (route) => false);
  }

  void goToClientHomePage() {
    Get.offNamedUntil('/client/home', (route) => false);
  }

  void goToRolesPage() {
    Get.offNamedUntil('/roles', (route) => false);
  }

  bool isValidForm(String email, String password) {
    if (email.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu email');
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Formulario no valido', 'El email no es valido');
      return false;
    }
    if (password.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu password');
      return false;
    }
    return true;
  }
}
