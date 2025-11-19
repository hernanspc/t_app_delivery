import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:delivery_app/src/providers/users_providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientProfileUpdateController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user'));

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  ClientProfileInfoController clientProfileInfoController = Get.find();

  ClientProfileUpdateController() {
    nameController.text = userSession.name ?? '';
    lastnameController.text = userSession.lastname ?? '';
    phoneController.text = userSession.phone ?? '';
  }

  UsersProvider usersProvider = UsersProvider();

  bool isValidForm(String name, String lastname, String phone) {
    if (name.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu Nombre');
      return false;
    }
    if (lastname.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu Apellido');
      return false;
    }
    if (phone.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu Telefono');
      return false;
    }

    return true;
  }

  void updateInfo(BuildContext context) async {
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;
    if (isValidForm(name, lastname, phone)) {
      ProgressDialog progressDialog = ProgressDialog(context: context);

      User myUser = User(
        id: userSession.id,
        name: name,
        lastname: lastname,
        phone: phone,
        token: userSession.token,
      );
      progressDialog.show(max: 100, msg: 'Actualizando datos');
      if (imageFile == null) {
        progressDialog.close();
        ResponseApi responseApi = await usersProvider.update(myUser);
        Get.snackbar('Proceso terminado ', responseApi.message ?? '');
        if (responseApi.success == true) {
          GetStorage().write('user', responseApi.data);
          clientProfileInfoController.user.value = User.fromJson(
            responseApi.data,
          );
        }
      } else {
        Stream stream = await usersProvider.updatedWithImage(
          myUser,
          imageFile!,
        );
        stream.listen((res) {
          progressDialog.close();
          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          print('Response Api update with image ${responseApi.data}');
          Get.snackbar('Proceso terminado ', responseApi.message ?? '');
          if (responseApi.success == true) {
            GetStorage().write('user', responseApi.data);
            clientProfileInfoController.user.value = User.fromJson(
              responseApi.data,
            );
          } else {
            Get.snackbar('Registro fallido', responseApi.message ?? '');
          }
        });
      }
      progressDialog.close();
    }
  }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery);
      },
      child: const Text("Gallery"),
    );
    Widget cameraButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.camera);
      },
      child: const Text("Camera"),
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text("Has una accion"),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
}
