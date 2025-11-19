import 'package:delivery_app/src/models/order.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/providers/orders_providers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DeliveryOrderListController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status = <String>['DESPACHADO', 'EN CAMINO', 'ENTREGADO'].obs;

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false); //ELIMINA HISTORIAL DE PANTALLAS
  }

  Future<List<Order>> getOrders(String status) async {
    return await ordersProvider.findByDeliveryAndStatus(
      userSession.id ?? '0',
      status,
    );
  }

  void goToOrderDetail(Order order) {
    Get.toNamed(
      '/delivery/orders/detail',
      arguments: {'order': order.toJson()},
    );
  }
}
