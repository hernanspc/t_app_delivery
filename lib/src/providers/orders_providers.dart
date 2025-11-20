import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/order.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OrdersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/orders';
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Order>> findByDeliveryAndStatus(
    String idDelivery,
    String status,
  ) async {
    Response response = await get(
      '$url/findByDeliveryAndStatus/$idDelivery/$status',
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar(
        'Peticion rechazada',
        'Tu usuario no tiene permitido leer esta información',
      );
      return [];
    }

    List<Order> orders = Order.fromJsonList(response.body);
    return orders;
  }

  Future<List<Order>> findByClientAndStatus(
    String idClient,
    String status,
  ) async {
    Response response = await get(
      '$url/findByClientAndStatus/$idClient/$status',
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );
    print('🟩 findByClientAndStatus: ${response.body}');

    if (response.statusCode == 401) {
      Get.snackbar(
        'Peticion rechazada',
        'Tu usuario no tiene permitido leer esta información',
      );
      return [];
    }

    List<Order> orders = Order.fromJsonList(response.body);
    return orders;
  }

  Future<List<Order>> findByStatus(String status) async {
    Response response = await get(
      '$url/findByStatus/$status',
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar(
        'Peticion rechazada',
        'Tu usuario no tiene permitido leer esta información',
      );
      return [];
    }

    List<Order> orders = Order.fromJsonList(response.body);
    return orders;
  }

  Future<ResponseApi> create(Order order) async {
    Response response = await post(
      '$url/create',
      order.toJson(),
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateToDispatched(Order order) async {
    Response response = await put(
      '$url/updateToDispatched',
      order.toJson(),
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateToOnTheWay(Order order) async {
    Response response = await put(
      '$url/updateToOnTheWay',
      order.toJson(),
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateToDelivered(Order order) async {
    Response response = await put(
      '$url/updateToDelivered',
      order.toJson(),
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateLatLng(Order order) async {
    Response response = await put(
      '$url/updateLatLng',
      order.toJson(),
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
