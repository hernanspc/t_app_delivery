import 'package:delivery_app/src/blocs/gps/gps_bloc.dart';
import 'package:delivery_app/src/blocs/notifications/notifications_bloc.dart';
import 'package:delivery_app/src/pages/client/orders/client_orders_list_page.dart';
import 'package:delivery_app/src/pages/client/products/client_products_list_page.dart';
import 'package:delivery_app/src/pages/client/products/client_products_list_page2.dart';
import 'package:delivery_app/src/pages/client/profile/client_profile_info_page.dart';

import 'package:delivery_app/src/utils/custom_animated_bottom_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  /// 🔹 Reemplaza RxInt de GetX
  final ValueNotifier<int> indexTab = ValueNotifier<int>(0);

  void changeTab(int index) {
    indexTab.value = index;
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await _requestLocationPermission();
      await _requestNotificationPermission();
    });
  }

  Future<void> _requestNotificationPermission() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    print("🔔 Estado permiso: ${settings.authorizationStatus}");
    final notificationBloc = context.read<NotificationsBloc>();
    notificationBloc.requestPermission();
  }

  Future<void> _requestLocationPermission() async {
    final gpsBloc = context.read<GpsBloc>();

    if (!gpsBloc.state.isGpsPermissionGranted) {
      await gpsBloc.askGpsAccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: ValueListenableBuilder<int>(
        valueListenable: indexTab,
        builder: (_, currentIndex, __) {
          return IndexedStack(
            index: currentIndex,
            children: [
              ClientProductsListPage(),
              ClientProductsListPage2(),
              ClientOrdersListPage(),
              ClientProfileInfoPage(),
            ],
          );
        },
      ),
    );
  }

  Widget _bottomBar() {
    return ValueListenableBuilder<int>(
      valueListenable: indexTab,
      builder: (_, currentIndex, __) {
        return CustomAnimatedBottomBar(
          containerHeight: 70,
          backgroundColor: Colors.amber,
          showElevation: true,
          itemCornerRadius: 30,
          curve: Curves.easeIn,
          selectedIndex: currentIndex,
          items: [
            BottomNavyBarItem(
              icon: const Icon(EvaIcons.home),
              title: const Text('Home'),
              activeColor: Colors.white,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem(
              icon: const Icon(EvaIcons.home),
              title: const Text('Home2'),
              activeColor: Colors.white,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem(
              icon: const Icon(EvaIcons.list),
              title: const Text('Mis pedidos'),
              activeColor: Colors.white,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem(
              icon: const Icon(EvaIcons.person),
              title: const Text('Perfil'),
              activeColor: Colors.white,
              inactiveColor: Colors.black,
            ),
          ],
          onItemSelected: changeTab,
        );
      },
    );
  }
}
