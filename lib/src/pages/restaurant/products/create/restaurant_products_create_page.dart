import 'dart:io';

import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/components/common/custom_text_form_field.dart';
import 'package:delivery_app/src/models/category.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RestaurantProductsCreatePage extends StatelessWidget {
  User user = User.fromJson(GetStorage().read('user'));

  RestaurantProductsCreateController con = Get.put(
    RestaurantProductsCreateController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              _backgroundCover(context),
              _boxForm(context),
              _textNewCategory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textNewCategory() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        alignment: Alignment.topCenter,
        child: Text(
          "Nueva Producto",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
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
      height: MediaQuery.of(context).size.height * 0.7,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.18,
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
            const SizedBox(height: 10),
            _textFieldPrice(),
            _dropDownCategories(con.categories),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<RestaurantProductsCreateController>(
                    builder: (values) => _cardImage(context, con.imageFile1, 1),
                  ),
                  // SizedBox(width: 5),
                  GetBuilder<RestaurantProductsCreateController>(
                    builder: (values) => _cardImage(context, con.imageFile2, 2),
                  ),
                  // SizedBox(width: 5),
                  GetBuilder<RestaurantProductsCreateController>(
                    builder: (values) => _cardImage(context, con.imageFile3, 3),
                  ),
                ],
              ),
            ),
            _buttonCreate(context),
          ],
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
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

  Widget _textFieldPrice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomTextFormField(
        controller: con.priceController,
        label: 'Precio',
        keyboardType: TextInputType.text,
        prefixIcon: Icons.attach_money,
      ),
    );
  }

  List<DropdownMenuItem<String?>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(
        DropdownMenuItem(child: Text(category.name ?? ''), value: category.id),
      );
    });
    return list;
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: const Icon(Icons.arrow_drop_down_circle, color: Colors.amber),
        ),
        elevation: 3,
        isExpanded: true,
        hint: const Text(
          "Seleccionar categoria",
          style: TextStyle(fontSize: 15),
        ),
        items: _dropDownItems(categories),
        value: con.idCategory.value == '' ? null : con.idCategory.value,
        onChanged: (option) {
          print('Opcion selecciona ${option} ');
          con.idCategory.value = option.toString();
        },
      ),
    );
  }

  Widget _cardImage(BuildContext context, File? imageFile, int numberFile) {
    return GetBuilder<RestaurantProductsCreateController>(
      builder: (value) => GestureDetector(
        onTap: () => con.showAlertDialog(context, numberFile),
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 70,
          width: MediaQuery.of(context).size.width * 0.18,
          child: imageFile != null
              ? Image.file(imageFile, fit: BoxFit.cover)
              : const Image(image: AssetImage("assets/img/cover_image.png")),
        ),
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: CustomFilledButton(
        text: 'Crear Producto',
        onPressed: () => con.createProduct(context),
      ),
    );
  }
}
