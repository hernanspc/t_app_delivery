import 'dart:convert';
import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/order.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrdersProvider {
  final String url = '${Environment.API_URL}api/orders';
  late User userSession;

  OrdersProvider() {
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

  Future<List<Order>> findByDeliveryAndStatus(
    String idDelivery,
    String status,
  ) async {
    await _loadUserSession();

    final uri = Uri.parse('$url/findByDeliveryAndStatus/$idDelivery/$status');
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return Order.fromJsonList(body);
    } else if (response.statusCode == 401) {
      throw Exception('Tu usuario no tiene permitido leer esta información');
    } else {
      throw Exception('Error al obtener órdenes por delivery y estado');
    }
  }

  Future<List<Order>> findByClientAndStatus(
    String idClient,
    String status,
  ) async {
    await _loadUserSession();

    final uri = Uri.parse('$url/findByClientAndStatus/$idClient/$status');
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return Order.fromJsonList(body);
    } else if (response.statusCode == 401) {
      throw Exception('Tu usuario no tiene permitido leer esta información');
    } else {
      throw Exception('Error al obtener órdenes por cliente y estado');
    }
  }

  Future<List<Order>> findByStatus(String status) async {
    await _loadUserSession();

    final uri = Uri.parse('$url/findByStatus/$status');
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return Order.fromJsonList(body);
    } else if (response.statusCode == 401) {
      throw Exception('Tu usuario no tiene permitido leer esta información');
    } else {
      throw Exception('Error al obtener órdenes por estado');
    }
  }

  Future<ResponseApi> create(Order order) async {
    await _loadUserSession();

    final uri = Uri.parse('$url/create');
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ResponseApi.fromJson(jsonDecode(response.body));
    } else {
      return ResponseApi(success: false, message: 'Error al crear la orden');
    }
  }

  Future<ResponseApi> updateToDispatched(Order order) async =>
      _updateOrder('$url/updateToDispatched', order);

  Future<ResponseApi> updateToOnTheWay(Order order) async =>
      _updateOrder('$url/updateToOnTheWay', order);

  Future<ResponseApi> updateToDelivered(Order order) async =>
      _updateOrder('$url/updateToDelivered', order);

  Future<ResponseApi> updateLatLng(Order order) async =>
      _updateOrder('$url/updateLatLng', order);

  Future<ResponseApi> _updateOrder(String endpoint, Order order) async {
    await _loadUserSession();

    final uri = Uri.parse(endpoint);
    final response = await http.put(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 200) {
      return ResponseApi.fromJson(jsonDecode(response.body));
    } else {
      return ResponseApi(
        success: false,
        message: 'Error al actualizar la orden',
      );
    }
  }
}
