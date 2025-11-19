import 'package:delivery_app/src/models/category.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/providers/categories_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RestaurantCategoriesCreateController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  CategoriesProvider categoriesProvider = CategoriesProvider();

  void createCategory() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      Category category = Category(name: name, description: description);
      ResponseApi responseApi = await categoriesProvider.create(category);
      Get.snackbar('Proceso terminado', responseApi.message ?? '');
      if (responseApi.success == true) {
        clearForm();
      }
    } else {
      Get.snackbar(
        'Formulario no valido',
        'Ingresa todos los campos para crear la categoria.',
      );
    }
  }

  void clearForm() {
    nameController.text = '';
    descriptionController.text = '';
  }
}
