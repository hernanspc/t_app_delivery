import 'dart:convert';
import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/address.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddressProvider {
  final String url = '${Environment.API_URL}api/address';
  late User userSession;

  AddressProvider() {
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

  Future<List<Address>> findByIdUser(String idUser) async {
    await _loadUserSession(); // Asegurarse de tener la sesión cargada

    final uri = Uri.parse('$url/findByIdUser/$idUser');
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return Address.fromJsonList(body);
    } else if (response.statusCode == 401) {
      throw Exception('Tu usuario no tiene permitido leer esta información');
    } else {
      throw Exception('Error de conexión al obtener direcciones');
    }
  }

  Future<ResponseApi> create(Address address) async {
    await _loadUserSession(); // Asegurarse de tener la sesión cargada

    final uri = Uri.parse('$url/create');
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
      body: jsonEncode(address.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return ResponseApi.fromJson(body);
    } else {
      return ResponseApi(success: false, message: 'Error de conexión');
    }
  }
}
