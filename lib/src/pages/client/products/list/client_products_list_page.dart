import 'package:delivery_app/src/models/category.dart';
import 'package:delivery_app/src/models/product.dart';
import 'package:delivery_app/src/pages/client/orders/create/client_orders_create_controllers.dart';
import 'package:delivery_app/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:delivery_app/src/widgets/loader_widget.dart';
import 'package:delivery_app/src/widgets/no_data_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProductsListPage extends StatelessWidget {
  ClientProductsListController con = Get.put(ClientProductsListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: con.categories.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: AppBar(
              flexibleSpace: Container(
                margin: EdgeInsets.only(top: 5),
                alignment: Alignment.topCenter,
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [_textFieldSearch(context), _iconShoppingBag()],
                ),
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.amber,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                tabs: List<Widget>.generate(con.categories.length, (index) {
                  return Tab(child: Text(con.categories[index].name ?? ''));
                }),
              ),
            ),
          ),
          body: TabBarView(
            children: con.categories.map((Category category) {
              return FutureBuilder(
                future: con.getProducts(
                  category.id ?? '1',
                  con.productName.value,
                ),
                builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) {
                          return _cardProduct(context, snapshot.data![index]);
                        },
                      );
                    } else {
                      return NoDataWidget(
                        text: "No hay productos disponibles, por el momento..",
                      );
                    }
                  } else {
                    return LoaderWidget(text: "Cargando productos.");
                    ;
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _iconShoppingBag() {
    return SafeArea(
      child: con.items.value > 0
          ? Stack(
              children: [
                IconButton(
                  icon: Icon(EvaIcons.shoppingCartOutline, size: 30),
                  onPressed: () => con.goToOrderCreate(),
                ),
                Positioned(
                  top: 5,
                  left: 25,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${con.items.value}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : IconButton(
              icon: Icon(EvaIcons.shoppingCartOutline, size: 30),
              onPressed: () => con.goToOrderCreate(),
            ),
    );
  }

  Widget _textFieldSearch(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextField(
          onChanged: con.onChangeText,
          decoration: InputDecoration(
            hintText: 'Buscar producto',
            suffixIcon: Icon(Icons.search, color: Colors.grey),
            hintStyle: TextStyle(
              fontSize: 17,
              color: const Color.fromARGB(255, 208, 206, 206),
            ),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 208, 206, 206),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 208, 206, 206),
              ),
            ),
            contentPadding: EdgeInsets.all(15),
          ),
        ),
      ),
    );
  }

  Widget _cardProduct(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => con.openBottomSheet(context, product),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              title: Text(product.name ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    product.description ?? '',
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'S/. ${product.price.toString()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 70,
                  width: 60,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 50),
                    image: product.image2 != null
                        ? NetworkImage(product.image1!)
                        : const AssetImage('assets/img/no-image.png')
                              as ImageProvider,
                    // placeholder: AssetImage('assets/img/no-image.png'),
                    placeholder: const AssetImage('assets/img/jar-loading.gif'),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey[300],
            indent: 30,
            endIndent: 30,
          ),
        ],
      ),
    );
  }
}
