import 'package:delivery_app/src/models/product.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:delivery_app/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:delivery_app/src/utils/relative_time_util.dart';
import 'package:delivery_app/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantOrdersDetailPage extends StatelessWidget {
  RestaurantOrdersDetailController con = RestaurantOrdersDetailController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          height: con.order.status == 'PAGADO'
              ? MediaQuery.of(context).size.height * 0.55
              : MediaQuery.of(context).size.height * 0.45,
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              _dataClient(),
              _addressClient(),
              _dataDate(),
              _dataDelivery(),
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
        con.order.status == 'PAGADO'
            ? Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 30, top: 10),
                child: Text(
                  'Asignar repartidor',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.amber,
                  ),
                ),
              )
            : Container(),
        con.order.status == 'PAGADO'
            ? _dropDownDeliveryMen(con.users)
            : Container(),
        Container(
          margin: EdgeInsets.only(top: 25, left: 20),
          child: Row(
            mainAxisAlignment: con.order.status == 'PAGADO'
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                'TOTAL S/. ${con.total.value}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              con.order.status == 'PAGADO'
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                        ),
                        onPressed: () => con.updateOrder(),
                        child: const Text('Despachar Orden'),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dataClient() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Cliente y Telefono'),
        subtitle: Text(
          '${con.order.client?.name ?? ''} ${con.order.client?.lastname ?? ''} - ${con.order.client?.phone ?? ''}',
        ),
        trailing: Icon(Icons.person_3),
        titleTextStyle: TextStyle(fontSize: 15, color: Colors.black),
        subtitleTextStyle: TextStyle(fontSize: 13, color: Colors.black),
      ),
    );
  }

  Widget _dataDelivery() {
    return con.order.status != 'PAGADO'
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              title: Text('Repartidor Asignado'),
              subtitle: Text(
                '${con.order.delivery?.name ?? ''} ${con.order.delivery?.lastname ?? ''} - ${con.order.delivery?.phone ?? ''}',
              ),
              trailing: Icon(Icons.delivery_dining),
              titleTextStyle: TextStyle(fontSize: 15, color: Colors.black),
              subtitleTextStyle: TextStyle(fontSize: 13, color: Colors.black),
            ),
          )
        : Container();
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

  List<DropdownMenuItem<String?>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(
        DropdownMenuItem(
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                child: FadeInImage(
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: const AssetImage('assets/img/jar-loading.gif'),
                  image: user.image != null
                      ? NetworkImage(user.image!)
                      : const AssetImage('assets/img/jar-loading.gif')
                            as ImageProvider,
                ),
              ),
              SizedBox(width: 15),
              Text(user.name ?? ''),
            ],
          ),
          value: user.id,
        ),
      );
    });
    return list;
  }

  Widget _dropDownDeliveryMen(List<User> users) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      margin: const EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: const Icon(Icons.arrow_drop_down_circle, color: Colors.amber),
        ),
        elevation: 3,
        isExpanded: true,
        hint: const Text(
          "Seleccionar repartidor",
          style: TextStyle(fontSize: 15),
        ),
        items: _dropDownItems(users),
        value: con.idDelivery.value == '' ? null : con.idDelivery.value,
        onChanged: (option) {
          print('Opcion selecciona ${option} ${con.idDelivery.value} ');
          con.idDelivery.value = option.toString();
        },
      ),
    );
  }
}
