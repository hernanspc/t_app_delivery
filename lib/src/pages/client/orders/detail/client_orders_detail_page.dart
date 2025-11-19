import 'package:delivery_app/src/models/product.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/pages/client/orders/detail/client_orders_detail_controller.dart';
import 'package:delivery_app/src/pages/delivery/orders/detail/delivery_orders_detail_controller.dart';
import 'package:delivery_app/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:delivery_app/src/utils/relative_time_util.dart';
import 'package:delivery_app/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientOrdersDetailPage extends StatelessWidget {
  ClientOrdersDetailController con = ClientOrdersDetailController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          height: con.order.status == 'EN CAMINO'
              ? MediaQuery.of(context).size.height * 0.4
              : MediaQuery.of(context).size.height * 0.35,
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              _dataDelivery(),
              _addressClient(),
              _dataDate(),
              _totalToPay(context),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            '#Orden: ${con.order.id}',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: con.order.products!.isNotEmpty
            ? ListView(
                children: con.order.products!.map((Product product) {
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
              Text(
                'Cantidad: ${product.quantity}',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      height: 50,
      width: 50,
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

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300], endIndent: 15, indent: 15),
        Container(
          margin: EdgeInsets.only(
            top: 25,
            left: con.order.status == 'EN CAMINO' ? 30 : 37,
          ),
          child: Row(
            mainAxisAlignment: con.order.status == 'EN CAMINO'
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                'TOTAL S/. ${con.total.value}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              con.order.status == 'EN CAMINO'
                  ? _buttonGoToOrderMap()
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dataDelivery() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Nombre de Repartidor'),
        subtitle: Text(
          '${con.order.delivery?.name ?? 'No asignado aun'} ${con.order.delivery?.lastname ?? ''} - ${con.order.delivery?.phone ?? '###'}',
        ),
        trailing: Icon(Icons.delivery_dining),
        titleTextStyle: TextStyle(fontSize: 15, color: Colors.black),
        subtitleTextStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
    );
  }

  Widget _addressClient() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Direccion'),
        subtitle: Text('${con.order.address?.address ?? ''}'),
        trailing: Icon(Icons.location_on),
        titleTextStyle: TextStyle(fontSize: 15, color: Colors.black),
        subtitleTextStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
    );
  }

  Widget _dataDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Fecha de pedido'),
        subtitle: Text(
          '${RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)}',
        ),
        trailing: Icon(Icons.timer),
        titleTextStyle: TextStyle(fontSize: 15, color: Colors.black),
        subtitleTextStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
    );
  }

  Widget _buttonGoToOrderMap() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15),
          backgroundColor: Colors.redAccent[200],
        ),
        onPressed: () => con.goToOrderMap(),
        child: Text('RASTREAR PEDIDO', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
