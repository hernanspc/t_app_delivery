import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/login/login_response.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UsersProvider {
  final String url = '${Environment.API_URL}api/users';
  late User userSession;

  // Crear usuario sin imagen
  Future<http.Response> create(User user) async {
    final uri = Uri.parse('$url/create');
    return await http.post(
      uri,
      headers: {"Content-Type": 'application/json'},
      body: jsonEncode(user.toJson()),
    );
  }

  // Actualizar token de notificación
  Future<ResponseApi> updateNotificationToken(String id, String token) async {
    final uri = Uri.parse('$url/updateNotificationToken');

    final response = await http.put(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
      body: jsonEncode({'id': id, 'token': token}),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return ResponseApi.fromJson(jsonDecode(response.body));
    } else {
      return ResponseApi(
        success: false,
        message: 'No se pudo actualizar información',
      );
    }
  }

  // Actualizar usuario sin imagen
  Future<ResponseApi> update(User user) async {
    final uri = Uri.parse('$url/updateWithoutImage');

    final response = await http.put(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return ResponseApi.fromJson(jsonDecode(response.body));
    } else {
      return ResponseApi(
        success: false,
        message: 'No se pudo actualizar información',
      );
    }
  }

  // Actualizar usuario con imagen
  Future<Stream<String>> updatedWithImage(User user, File image) async {
    final uri = Uri.parse('$url/update');

    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'JWT ${userSession.token ?? ''}';

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        filename: basename(image.path),
      ),
    );
    request.fields['user'] = jsonEncode(user.toJson());

    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  // Crear usuario con imagen
  Future<Stream<String>> createdWithImage(User user, File image) async {
    final uri = Uri.parse('$url/createWithImage');

    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        filename: basename(image.path),
      ),
    );
    request.fields['user'] = jsonEncode(user.toJson());

    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  // Login
  Future<LoginResponse> login(String email, String password) async {
    print('🟦 input : $email $password');
    final uri = Uri.parse('$url/login');

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "piEMPRESA": Environment.EMPRESA_CODE,
        "psUSUARIO": email,
        "clave": password,
      }),
    );
    print("🟦 users_providers login: ${response.body}");
    return LoginResponse.fromJson(jsonDecode(response.body));
  }

  // Obtener repartidores
  Future<List<User>> findDeliveryMen() async {
    final uri = Uri.parse('$url/findDeliveryMen');

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List<dynamic> body = jsonDecode(response.body);
      return User.fromJsonList(body);
    } else if (response.statusCode == 401) {
      throw Exception('Tu usuario no tiene permitido leer esta información');
    } else {
      throw Exception('Error al obtener la lista de repartidores');
    }
  }
}
