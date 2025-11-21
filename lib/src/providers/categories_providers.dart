import 'dart:convert';
import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/categories/categorias_response.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:http/http.dart' as http;

class CategoriesProvider {
  final String url = '${Environment.API_URL}api/categories';
  late User userSession;

  Future<CategoriasResponse> getAllCategories(
    int idTienda,
    int idUsuario,
  ) async {
    final uri = Uri.parse('$url/getAll');

    final response = await http.post(
      uri,
      headers: {"Content-Type": 'application/json'},
      body: jsonEncode({
        "piEMPRESA": Environment.EMPRESA_CODE,
        "piTIENDA": idTienda,
        "piUSUARIO": idUsuario,
      }),
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
}
