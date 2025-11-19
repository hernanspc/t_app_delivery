import 'package:delivery_app/src/models/product.dart';
import 'package:delivery_app/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProductDetailController extends GetxController {
  List<Product> selectedProducts = [];

  ClientProductsListController clientProductsListController = Get.find();

  ClientProductDetailController() {}

  void checkIfProductWasAdded(Product product, var price, var counter) {
    price.value = product.price ?? 0.0;

    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      } else {
        selectedProducts = Product.fromJsonList(
          GetStorage().read('shopping_bag'),
        );
      }

      int index = selectedProducts.indexWhere((p) => p.id == product!.id);

      if (index != -1) {
        counter.value = selectedProducts[index].quantity ?? 0;
        price.value = product.price! * counter.value;
        selectedProducts.forEach((p) {
          print('👂👂 Product: ${p.toJson()}');
        });
      }
    }
  }

  void addToBag(Product product, var price, var counter) {
    if (counter.value > 0) {
      //Validar si el producto ya fue agregado con get Storage a la sesion del dispositivo.
      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if (index == -1) {
        if (product.quantity == null) {
          if (counter.value > 0) {
            product.quantity = counter.value;
          } else {
            product.quantity = 1;
          }
        }
        selectedProducts.add(product);
      } else {
        // ya ha sido agregado en storage
        selectedProducts[index].quantity = counter.value;
      }

      GetStorage().write('shopping_bag', selectedProducts);
      Fluttertoast.showToast(msg: 'Producto agregado');
      clientProductsListController.items.value = 0;
      selectedProducts.forEach((p) {
        clientProductsListController.items.value =
            clientProductsListController.items.value + p.quantity!;
      });
      //Una ves seleccionado quitamos la modal
      Get.back();
      // GetStorage().remove('shopping_bag');
    } else {
      Fluttertoast.showToast(msg: 'Debes seleccionar almenos un elemento');
    }
  }

  void addItem(Product product, var price, var counter) {
    counter.value = counter.value + 1;
    price.value = product!.price! * counter.value;
  }

  void removeItem(Product product, var price, var counter) {
    if (counter.value > 0) {
      counter.value = counter.value - 1;
      price.value = product!.price! * counter.value;
    }
  }
}
