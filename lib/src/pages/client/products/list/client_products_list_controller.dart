import 'dart:async';

import 'package:delivery_app/src/models/category.dart';
import 'package:delivery_app/src/models/product.dart';
import 'package:delivery_app/src/pages/client/products/detail/client_product_detail_page.dart';
import 'package:delivery_app/src/providers/categories_providers.dart';
import 'package:delivery_app/src/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'; // Cambia esta importación

class ClientProductsListController extends GetxController {
  CategoriesProvider categoriesProvider = CategoriesProvider();
  ProductsProvider productsProvider = ProductsProvider();

  List<Category> categories = <Category>[].obs;
  var items = 0.obs;
  List<Product> selectedProducts = [];

  var productName = "".obs;
  Timer? searchOnStoppedTyping;

  ClientProductsListController() {
    getCategories();

    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      } else {
        selectedProducts = Product.fromJsonList(
          GetStorage().read('shopping_bag'),
        );
      }

      selectedProducts.forEach((p) {
        items.value = items.value + (p.quantity!);
      });
    }
  }

  onChangeText(String text) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping?.cancel();
    }

    searchOnStoppedTyping = Timer(duration, () {
      productName.value = text;
      print('YOU ARE WRITING ${productName}');
    });
  }

  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  Future<List<Product>> getProducts(
    String idCategory,
    String productName,
  ) async {
    print('getProducts 👁️ $productName ');

    if (productName.isEmpty) {
      return await productsProvider.findByCategory(idCategory);
    } else {
      return await productsProvider.findByNameAndCategory(
        idCategory,
        productName,
      );
    }
  }

  void openBottomSheet(BuildContext context, Product product) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => ClientProductDetailPage(product: product),
    );
  }

  void goToOrderCreate() {
    Get.toNamed('/client/orders/create');
  }
}
