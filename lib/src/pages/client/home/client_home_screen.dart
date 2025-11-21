import 'package:delivery_app/src/pages/client/orders/client_orders_list_page.dart';
import 'package:delivery_app/src/pages/client/products/client_products_list_page.dart';
import 'package:delivery_app/src/pages/client/products/client_products_list_page2.dart';
import 'package:delivery_app/src/pages/client/profile/client_profile_info_page.dart';

import 'package:delivery_app/src/utils/custom_animated_bottom_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

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
