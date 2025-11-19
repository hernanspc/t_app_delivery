import 'package:delivery_app/src/models/order.dart';
import 'package:delivery_app/src/providers/orders_providers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RestaurantOrderListController extends GetxController {
  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status = <String>[
    'PAGADO',
    'DESPACHADO',
    'EN CAMINO',
    'ENTREGADO',
  ].obs;

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false); //ELIMINA HISTORIAL DE PANTALLAS
  }

  Future<List<Order>> getOrders(String status) async {
    return await ordersProvider.findByStatus(status);
  }

  void goToOrderDetail(Order order) {
    Get.toNamed(
      '/restaurant/orders/detail',
      arguments: {'order': order.toJson()},
    );
  }
}
