import 'package:delivery_app/src/pages/client/home/client_home_controller.dart';
import 'package:delivery_app/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:delivery_app/src/pages/client/products/list/client_products_list_page.dart';
import 'package:delivery_app/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:delivery_app/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:delivery_app/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:delivery_app/src/utils/custom_animated_bottom_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientHomePage extends StatelessWidget {
  ClientHomeController con = Get.put(ClientHomeController());

  ClientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx(
        () => IndexedStack(
          index: con.indexTab.value,
          children: [
            ClientProductsListPage(),
            ClientOrdersListPage(),
            ClientProfileInfoPage(),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Obx(
      () => CustomAnimatedBottomBar(
        containerHeight: 70,
        backgroundColor: Colors.amber,
        showElevation: true,
        itemCornerRadius: 30,
        curve: Curves.easeIn,
        selectedIndex: con.indexTab.value,
        items: [
          BottomNavyBarItem(
            icon: Icon(EvaIcons.home),
            title: Text('Home'),
            activeColor: Colors.white,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(EvaIcons.list),
            title: Text('Mis pedidos'),
            activeColor: Colors.white,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(EvaIcons.person),
            title: Text('Perfil'),
            activeColor: Colors.white,
            inactiveColor: Colors.black,
          ),
        ],
        onItemSelected: (index) => con.changeTab(index),
      ),
    );
  }
}
