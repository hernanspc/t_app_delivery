import 'package:delivery_app/src/models/product.dart';
import 'package:delivery_app/src/pages/client/orders/create/client_orders_create_controllers.dart';
import 'package:delivery_app/src/widgets/no_data_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientOrdersCreatePage extends StatelessWidget {
  ClientOrdersCreateController con = Get.put(ClientOrdersCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          height: 100,
          child: _totalToPay(context),
        ),
        appBar: AppBar(
          title: Text("Mi orden", style: TextStyle(color: Colors.black)),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: con.selectedProducts.length > 0
            ? ListView(
                children: con.selectedProducts.map((Product product) {
                  return _cardProducts(product);
                }).toList(),
              )
            : NoDataWidget(text: 'No hay ningun producto agregado aun.'),
      ),
    );
  }

  Widget _cardProducts(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7),
              _buttonsAddOrRemove(product),
            ],
          ),
          Spacer(),
          Column(children: [_textPrice(product), _iconDelete(product)]),
        ],
      ),
    );
  }

  Widget _buttonsAddOrRemove(Product product) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => con.removeItem(product),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Text("-"),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: Colors.grey[200],
          child: Text("${product.quantity ?? 0}"),
        ),
        GestureDetector(
          onTap: () => con.addItem(product),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Text("+"),
          ),
        ),
      ],
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      height: 70,
      width: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          image: product.image2 != null
              ? NetworkImage(product.image1!)
              : const AssetImage('assets/img/no-image.png') as ImageProvider,
          // placeholder: AssetImage('assets/img/no-image.png'),
          placeholder: const AssetImage('assets/img/jar-loading.gif'),
        ),
      ),
    );
  }

  Widget _iconDelete(Product product) {
    return IconButton(
      onPressed: () => con.deleteItem(product),
      icon: Icon(EvaIcons.trash2, color: Colors.red),
    );
  }

  Widget _textPrice(Product product) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        'S/. ${product.price! * product.quantity!}',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300], endIndent: 15, indent: 15),
        Container(
          margin: EdgeInsets.only(top: 25, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TOTAL S/. ${con.total.value}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
                  onPressed: () => con.goToAddressList(),
                  child: const Text('Confirmar orden'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
