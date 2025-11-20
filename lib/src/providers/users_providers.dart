import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class UsersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/users';
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<Response> create(User user) async {
    Response response = await post(
      '$url/create',
      user.toJson(),
      headers: {"Content-type": 'application/json'},
    );

    return response;
  }

  Future<ResponseApi> updateNotificationToken(String id, String token) async {
    Response response = await put(
      '$url/updateNotificationToken',
      {'id': id, 'token': token},
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token}',
      },
    );

    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo actualizar informacion');
      return ResponseApi();
    }

    if (response.statusCode == 401) {
      Get.snackbar('Error', 'No esta autorizado para realizar esta petición');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  //SIN IMAGEN
  Future<ResponseApi> update(User user) async {
    Response response = await put(
      '$url/updateWithoutImage',
      user.toJson(),
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token}',
        // "Authorization": userSession.token!,
      },
    );

    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo actualizar informacion');
      return ResponseApi();
    }

    if (response.statusCode == 401) {
      Get.snackbar('Error', 'No esta autorizado para realizar esta petición');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  //CON IMAGEN
  Future<Stream> updatedWithImage(User user, File image) async {
    Uri uri = Uri.parse('${Environment.API_URL}api/users/update');

    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'JWT ${userSession.token}';
    // request.headers['Authorization'] = userSession.token!;

    request.files.add(
      http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path),
      ),
    );
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<Stream> createdWithImage(User user, File image) async {
    // Uri uri = Uri.http(url, '/createWithImage');
    Uri uri = Uri.parse('${Environment.API_URL}api/users/createWithImage');

    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path),
      ),
    );
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<ResponseApi> login(String email, String password) async {
    Response response = await post(
      '$url/login',
      {
        "piEMPRESA": Environment.EMPRESA_CODE,
        "psUSUARIO": email,
        "clave": password,
      },
      headers: {"Content-type": 'application/json'},
    );
    if (response.body == null) {
      // Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<List<User>> findDeliveryMen() async {
    Response response = await get(
      '$url/findDeliveryMen',
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response == null || response.body == null) {
      // Si la respuesta es nula o el cuerpo de la respuesta es nulo, manejar el error
      Get.snackbar(
        'Error de conexión',
        'No se pudo obtener la lista de categorías',
      );
      return []; // Devolver una lista vacía u otra respuesta de error según tu lógica de la aplicación
    }

    if (response.statusCode == 401) {
      Get.snackbar(
        'Peticion rechazada',
        'Tu usuario no tiene permitido leer esta información',
      );
      return [];
    }

    List<User> users = User.fromJsonList(response.body);
    return users;
  }
}
