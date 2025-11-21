import 'dart:convert';

import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/product/product.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductsProvider {
  final String url = '${Environment.API_URL}api/products';
  late User userSession;

  ProductsProvider() {
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      userSession = Product.fromJson(jsonDecode(userJson)) as User;
    } else {
      userSession = User();
    }
  }

  Future<List<Product>> findByCategory(
    int idTienda,
    int idUsuario,
    int idCategory,
  ) async {
    try {
      final uri = Uri.parse('$url/findbyCategory');
      final response = await http.post(
        uri,
        headers: {"Content-Type": 'application/json'},
        body: jsonEncode({
          "piEMPRESA": Environment.EMPRESA_CODE,
          "piTIENDA": idTienda,
          "piUSUARIO": idUsuario,
          "piCATEGORIA": idCategory,
        }),
      );

      print('response findByCategory: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return Product.fromJsonList(data);
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print("ERROR findByCategory → $e");
      return [];
    }
  }
}
