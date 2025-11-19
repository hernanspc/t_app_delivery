import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/address.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddressProvider extends GetConnect {
  String url = '${Environment.API_URL}api/address';
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Address>> findByIdUser(String idUser) async {
    Response response = await get(
      '$url/findByIdUser/$idUser',
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

    List<Address> addressUser = Address.fromJsonList(response.body);
    return addressUser;
  }

  Future<ResponseApi> create(Address address) async {
    Response response = await post(
      '$url/create',
      address.toJson(),
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
