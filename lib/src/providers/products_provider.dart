import 'dart:convert';

import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/categories/categories_products_response.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:http/http.dart' as http;

class ProductsProvider {
  final String url = '${Environment.API_URL}api/products';
  late User userSession;

  Future<List<CategoryAndProductsAll>> getAllCategoriesAndProducts({
    required int idTienda,
    required int idUsuario,
  }) async {
    try {
      final uri = Uri.parse('$url/getAllCategoriesAndProducts');
      final response = await http.post(
        uri,
        headers: {"Content-Type": 'application/json'},
        body: jsonEncode({
          "piEMPRESA": Environment.EMPRESA_CODE,
          "piTIENDA": idTienda,
          "piUSUARIO": idUsuario,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final categoriasJson = decoded['data']['CATEGORIAS'] as List<dynamic>;
        return categoriasJson
            .map((c) => CategoryAndProductsAll.fromJson(c))
            .toList();
      } else {
        print("Error en getAllCategoriesAndProducts: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("ERROR getAllCategoriesAndProducts → $e");
      return [];
    }
  }
}
