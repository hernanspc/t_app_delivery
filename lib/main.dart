import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/pages/client/address/create/client_address_create_page.dart';
import 'package:delivery_app/src/pages/client/address/list/client_address_list_page.dart';
import 'package:delivery_app/src/pages/client/home/client_home_page.dart';
import 'package:delivery_app/src/pages/client/orders/create/client_orders-create_page.dart';
import 'package:delivery_app/src/pages/client/orders/detail/client_orders_detail_page.dart';
import 'package:delivery_app/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:delivery_app/src/pages/client/orders/map/client_orders_map_page.dart';
import 'package:delivery_app/src/pages/client/payments/installments/client_payments_installments_page.dart';
import 'package:delivery_app/src/pages/client/payments/status/client_payments_status_page.dart';
import 'package:delivery_app/src/pages/client/products/list/client_products_list_page.dart';
import 'package:delivery_app/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:delivery_app/src/pages/client/profile/update/client_profile_update_page.dart';
import 'package:delivery_app/src/pages/delivery/home/delivery_home_page.dart';
import 'package:delivery_app/src/pages/delivery/orders/detail/Delivery_orders_detail_page.dart';
import 'package:delivery_app/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:delivery_app/src/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:delivery_app/src/pages/home/home_page.dart';
import 'package:delivery_app/src/pages/login/login_page.dart';
import 'package:delivery_app/src/pages/client/payments/create/client_payments_create_page.dart';
import 'package:delivery_app/src/pages/register/register_page.dart';
import 'package:delivery_app/src/pages/restaurant/home/restaurant_home_page.dart';
import 'package:delivery_app/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:delivery_app/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:delivery_app/src/pages/roles/roles_page.dart';
import 'package:delivery_app/src/providers/pushNotificationProvider.dart';
import 'package:delivery_app/src/utils/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});

PushNotificationProvider pushNotificationProvider = PushNotificationProvider();

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print(
    'Handling a background message, recibiendo en segundo plano ${message.messageId}',
  );
  // pushNotificationProvider.showNotification(message);
}

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationProvider.initPushNotification();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    pushNotificationProvider.onMessaginListener();
  }

  @override
  Widget build(BuildContext context) {
    print('API_URL ${Environment.API_URL}');

    String? token = userSession.token;
    print('User login: token: ${token} ');
    bool isExpired = true;
    if (token != null) {
      isExpired = Jwt.isExpired(token);
      print(isExpired);
      if (isExpired) {
        GetStorage().remove('user');
      }
    }
    // Si el token es nulo, ocurrirá si no hay usuario o algún otro escenario, navegar a la página de inicio de sesión.
    return GetMaterialApp(
      title: "App Delivero",
      debugShowCheckedModeBanner: false,
      // initialRoute: '/client/payments/create',
      initialRoute: isExpired
          ? '/'
          : userSession.roles!.length > 1
          ? '/roles'
          : '/client/home',
      // initialRoute: isExpired ? '/' : '/roles',
      // initialRoute: userSession.token != null ? '/home' : '/', //antes.....
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/roles', page: () => RolesPage()),
        //RESTAURANT
        GetPage(name: '/restaurant/home', page: () => RestaurantHomePage()),
        GetPage(
          name: '/restaurant/orders/list',
          page: () => RestaurantOrderListPage(),
        ),
        GetPage(
          name: '/restaurant/orders/detail',
          page: () => RestaurantOrdersDetailPage(),
        ),
        //DELIVERY
        GetPage(name: '/delivery/home', page: () => DeliveryHomePage()),
        GetPage(
          name: '/delivery/orders/list',
          page: () => DeliveryOrdersListPage(),
        ),
        GetPage(
          name: '/delivery/orders/detail',
          page: () => DeliveryOrdersDetailPage(),
        ),
        GetPage(
          name: '/delivery/orders/map',
          page: () => DeliveryOrdersMapPage(),
        ),

        //CLIENT
        GetPage(name: '/client/home', page: () => ClientHomePage()),
        GetPage(
          name: '/client/products/list',
          page: () => ClientProductsListPage(),
        ),
        GetPage(
          name: '/client/profile/info',
          page: () => ClientProfileInfoPage(),
        ),
        GetPage(
          name: '/client/profile/update',
          page: () => ClientProfileUpdatePage(),
        ),
        GetPage(
          name: '/client/orders/list',
          page: () => ClientOrdersListPage(),
        ),
        GetPage(
          name: '/client/orders/detail',
          page: () => ClientOrdersDetailPage(),
        ),
        GetPage(
          name: '/client/orders/create',
          page: () => ClientOrdersCreatePage(),
        ),
        GetPage(name: '/client/orders/map', page: () => ClientOrdersMapPage()),

        GetPage(
          name: '/client/address/list',
          page: () => ClientAddressListPage(),
        ),
        GetPage(
          name: '/client/address/create',
          page: () => ClientAddressCreatePage(),
        ),
        GetPage(
          name: '/client/payments/create',
          page: () => ClientPaymentsCreatePage(),
        ),
        GetPage(
          name: '/client/payments/installments',
          page: () => ClientPaymentsInstallmentsPage(),
        ),
        GetPage(
          name: '/client/payments/status',
          page: () => ClientPaymentsStatusPage(),
        ),
      ],
      theme: ThemeData(colorSchemeSeed: Colors.amber),
      navigatorKey: Get.key,
    );
  }
}
