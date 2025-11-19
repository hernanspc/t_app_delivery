import 'package:delivery_app/src/models/order.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/providers/orders_providers.dart';
import 'package:delivery_app/src/providers/users_providers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RestaurantOrdersDetailController extends GetxController {
  Order order = Order.fromJson(Get.arguments['order']);
  var total = 0.0.obs;
  var idDelivery = "".obs;
  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();

  List<User> users = <User>[].obs;

  RestaurantOrdersDetailController() {
    print(' este es tu order : ${order.toJson()}');
    getDeliveryMen();
    getTotal();
  }

  void updateOrder() async {
    if (idDelivery != 'null') {
      order.idDelivery = idDelivery.value;
      print('you order ${order.toJson()}');
      ResponseApi resposeApi = await ordersProvider.updateToDispatched(order);
      Fluttertoast.showToast(
        msg: resposeApi.message ?? '',
        toastLength: Toast.LENGTH_LONG,
      );
      if (resposeApi.success == true) {
        Get.offNamedUntil('/restaurant/home', (route) => false);
      } else {
        Get.snackbar('Peticion denegada', 'Debes asignar un repartidor');
      }
    }
  }

  void getDeliveryMen() async {
    var result = await usersProvider.findDeliveryMen();
    users.clear();
    users.addAll(result);
  }

  void getTotal() {
    total.value = 0.0;
    order.products!.forEach((product) {
      total.value = total.value + (product.quantity! * product.price!);
    });
  }
}
