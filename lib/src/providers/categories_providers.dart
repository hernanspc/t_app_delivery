import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/category.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CategoriesProvider extends GetConnect {
  String url = '${Environment.API_URL}api/categories';
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Category>> getAll() async {
    Response response = await get(
      '$url/getAll',
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

    List<Category> categories = Category.fromJsonList(response.body);
    return categories;
  }

  Future<ResponseApi> create(Category category) async {
    Response response = await post(
      '$url/create',
      category.toJson(),
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response == null || response.body == null) {
      // Manejar el error si la respuesta es nula o el cuerpo de la respuesta es nulo
      return ResponseApi(success: false, message: 'Error de conexión');
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }
}
