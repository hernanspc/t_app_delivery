import 'dart:async';
import 'package:delivery_app/src/models/product/product.dart';
import 'package:delivery_app/src/pages/client/products/client_product_detail_page.dart';
import 'package:delivery_app/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:delivery_app/src/models/categories/categorias_response.dart';
import 'package:delivery_app/src/providers/categories_providers.dart';
import 'package:delivery_app/src/providers/products_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ClientProductsListPageController extends ChangeNotifier {
  final CategoriesProvider categoriesProvider = CategoriesProvider();
  final ProductsProvider productsProvider = ProductsProvider();
  final AuthService auth; // ⬅️ AQUI GUARDAMOS LA SESIÓN

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

  ClientProductsListPageController(this.auth) {
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
    final tiendaId = auth.userSession?.tiendaId ?? 0;
    final usuarioId = auth.userSession?.usuarioId ?? 0;

    print(
      '🌈 Obteniendo categorías para tiendaId: $tiendaId y usuarioId: $usuarioId',
    );

    final response = await categoriesProvider.getAllCategories(
      tiendaId,
      usuarioId,
    );
    categoriasResponse = response;
    categorias = response.categorias;
  }

  /// Obtener productos
  Future<List<Product>> getProducts(int idCategory) {
    final tiendaId = auth.userSession?.tiendaId ?? 0;
    final usuarioId = auth.userSession?.usuarioId ?? 0;

    print("🔎 Buscando productos en categoría $idCategory");
    return productsProvider.findByCategory(tiendaId, usuarioId, idCategory);
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
