import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/product.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

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

  Future<List<Product>> findByCategory(String idCategory) async {
    await _loadUserSession();

    final uri = Uri.parse('$url/findbyCategory/$idCategory');
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return Product.fromJsonList(body);
    } else if (response.statusCode == 401) {
      throw Exception('Tu usuario no tiene permitido leer esta información');
    } else {
      throw Exception('Error al obtener productos por categoría');
    }
  }

  Future<List<Product>> findByNameAndCategory(
    String idCategory,
    String name,
  ) async {
    await _loadUserSession();

    final uri = Uri.parse('$url/findbyCategory/$idCategory/$name');
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return Product.fromJsonList(body);
    } else if (response.statusCode == 401) {
      throw Exception('Tu usuario no tiene permitido leer esta información');
    } else {
      throw Exception('Error al obtener productos por nombre y categoría');
    }
  }

  Future<Stream<String>> create(Product product, List<File> images) async {
    await _loadUserSession();

    final uri = Uri.parse('${Environment.API_URL}api/products/create');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'JWT ${userSession.token ?? ''}';

    for (final image in images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          filename: basename(image.path),
        ),
      );
    }

    request.fields['product'] = jsonEncode(product.toJson());

    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }
}
