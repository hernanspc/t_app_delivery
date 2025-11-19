import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/components/common/custom_text_form_field.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RestaurantCategoriesCreatePage extends StatelessWidget {
  User user = User.fromJson(GetStorage().read('user'));

  RestaurantCategoriesCreateController con = Get.put(
    RestaurantCategoriesCreateController(),
  );

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
          ],
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
            Icon(Icons.category, size: 100),
            Text(
              "Nueva Categoria",
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
            _textFieldDescription(),
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

  Widget _textFieldDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        controller: con.descriptionController,
        label: 'Description',
        keyboardType: TextInputType.text,
        prefixIcon: Icons.description,
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: CustomFilledButton(
        text: 'Crear Categoria',
        onPressed: () => con.createCategory(),
      ),
    );
  }
}
