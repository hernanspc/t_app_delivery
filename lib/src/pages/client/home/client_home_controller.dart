import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/providers/pushNotificationProvider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientHomeController extends GetxController {
  var indexTab = 0.obs;
  PushNotificationProvider pushNotificationProvider =
      PushNotificationProvider();

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  ClientHomeController() {
    saveToken();
  }

  void changeTab(int index) {
    indexTab.value = index;
  }

  void saveToken() {
    if (userSession.id != null) {
      pushNotificationProvider.saveToken(userSession.id!);
    }
  }

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false); //ELIMINA HISTORIAL DE PANTALLAS
  }
}
