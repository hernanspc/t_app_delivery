import 'dart:convert';
import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/categories/categorias_response.dart';
import 'package:delivery_app/src/models/category.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesProvider {
  final String url = '${Environment.API_URL}api/categories';
  late User userSession;

  CategoriesProvider() {
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      userSession = User.fromJson(jsonDecode(userJson));
    } else {
      userSession = User();
    }
  }

  Future<CategoriasResponse> getAll() async {
    await _loadUserSession();

    final uri = Uri.parse('$url/getAll');

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": "JWT ${userSession.token ?? ''}",
      },
      body: jsonEncode({"piEMPRESA": 1, "piTIENDA": 1, "piUSUARIO": 1}),
    );

    // Debug útil
    print("🟦 categories_provider response: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      // Retornar TODA la respuesta tipada
      return CategoriasResponse.fromJson(json);
    }

    if (response.statusCode == 401) {
      throw Exception("Tu usuario no tiene permitido leer esta información");
    }

    throw Exception("Error de conexión al obtener categorías");
  }

  Future<ResponseApi> create(Category category) async {
    await _loadUserSession(); // Asegurarse de tener la sesión cargada

    final uri = Uri.parse('$url/create');
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return ResponseApi.fromJson(body);
    } else {
      return ResponseApi(success: false, message: 'Error de conexión');
    }
  }
}
