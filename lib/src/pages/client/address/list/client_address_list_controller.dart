import 'package:delivery_app/src/models/address.dart';
import 'package:delivery_app/src/models/order.dart';
import 'package:delivery_app/src/models/product.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/pages/client/orders/create/client_orders_create_controllers.dart';
import 'package:delivery_app/src/providers/address_provider.dart';
import 'package:delivery_app/src/providers/orders_providers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientAddressListController extends GetxController {
  List<Address> address = [];
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  var radioValue = 0.obs;

  AddressProvider addressProvider = AddressProvider();
  OrdersProvider ordersProvider = OrdersProvider();

  ClientOrdersCreateController clientOrdersCreateController = Get.find();

  ClientAddressListController() {
    getAddress();
  }

  Future<List<Address>> getAddress() async {
    address = await addressProvider.findByIdUser(userSession.id ?? '');
    Address? a;
    var addressStorage = GetStorage().read('address');
    if (addressStorage != null) {
      a = Address.fromJson(addressStorage);
    } else {
      print('No hay dirección guardada en GetStorage');
    }

    int index = a != null ? address.indexWhere((ad) => ad.id == a!.id) : -1;
    //LA DIRECCION DE SESION COINCIDE CON DATO DE LA LISTA DE DIRECCIONES
    if (index != -1) {
      radioValue.value = index;
    }
    return address;
  }

  void createOrder() async {
    Address a = Address.fromJson(GetStorage().read('address'));

    List<Product> products = [];
    if (GetStorage().read('shopping_bag') is List<Product>) {
      products = GetStorage().read('shopping_bag');
    } else {
      products = Product.fromJsonList(GetStorage().read('shopping_bag'));
    }

    Order order = Order(
      idClient: userSession.id,
      idAddress: a.id,
      products: products,
    );

    ResponseApi responseApi = await ordersProvider.create(order);

    Fluttertoast.showToast(
      msg: responseApi.message ?? '',
      toastLength: Toast.LENGTH_LONG,
    );

    if (responseApi.success == true) {
      GetStorage().remove('shopping_bag');
      clientOrdersCreateController.clearSelectedProducts();
      Get.offNamedUntil('/client/home', (route) => false); //ELIMINA
    }
  }

  void createOrderWithPayment() async {
    Get.toNamed('/client/payments/create');
  }

  void goToAddressCreate() {
    Get.toNamed('/client/address/create');
  }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    print('VALOR :  $value');
    GetStorage().write('address', address[value].toJson());
    update();
  }
}
