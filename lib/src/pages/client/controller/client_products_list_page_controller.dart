import 'dart:async';
import 'package:delivery_app/src/models/product/product.dart';
import 'package:delivery_app/src/pages/client/products/client_product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:delivery_app/src/models/categories/categorias_response.dart';
import 'package:delivery_app/src/providers/categories_providers.dart';
import 'package:delivery_app/src/providers/products_provider.dart';

class ClientProductsListPageController extends ChangeNotifier {
  final CategoriesProvider categoriesProvider = CategoriesProvider();
  final ProductsProvider productsProvider = ProductsProvider();

  /// Toda la respuesta (success + mensaje + categorias)
  CategoriasResponse? categoriasResponse;

  /// Lista tipada de categorías
  List<Categoria> categorias = [];

  /// Productos seleccionados (carrito)
  List<Product> selectedProducts = [];

  /// Ítems del carrito
  int items = 0;

  /// Nombre de búsqueda
  final ValueNotifier<String> productName = ValueNotifier("");

  Timer? searchOnStoppedTyping;

  ClientProductsListPageController() {
    _init();
  }

  Future<void> _init() async {
    await getCategorias();
    notifyListeners(); // ← SE NOTIFICA SOLO UNA VEZ DESPUÉS DE CARGAR
  }

  /// Busca con delay
  void onChangeText(String text) {
    searchOnStoppedTyping?.cancel();

    searchOnStoppedTyping = Timer(const Duration(milliseconds: 800), () {
      productName.value = text;
      notifyListeners();
    });
  }

  /// Obtener categorías usando CategoriasResponse
  Future<void> getCategorias() async {
    final response = await categoriesProvider.getAllCategories(1, 1);
    categoriasResponse = response;
    categorias = response.categorias;
  }

  /// Obtener productos
  Future<List<Product>> getProducts(int idCategory) {
    print("🔎 Buscando productos en categoría $idCategory");
    return productsProvider.findByCategory(1, 1, idCategory);
  }

  /// Abrir detalle
  void openBottomSheet(BuildContext context, Product product) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (_) => ClientProductDetailPage(product: product),
    );
  }

  /// Navegación tradicional
  void goToOrderCreate(BuildContext context) {
    Navigator.pushNamed(context, "/client/orders/create");
  }

  /// Recargar categorías manualmente
  Future<void> reloadCategories() async {
    await getCategorias();
    notifyListeners(); // ← aquí sí
  }
}
