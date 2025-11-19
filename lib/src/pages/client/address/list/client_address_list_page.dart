import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/src/models/address.dart';
import 'package:delivery_app/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:delivery_app/src/widgets/no_data_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientAddressListPage extends StatefulWidget {
  @override
  State<ClientAddressListPage> createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {
  ClientAddressListController con = Get.put(ClientAddressListController());

  @override
  void initState() {
    super.initState();
    con.getAddress(); // Llamada a getAddress() cuando se inicializa el widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: _buttonNext(context),
      bottomNavigationBar: _buttonNextPayment(context),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Tus direcciones',
          style: TextStyle(color: Colors.black),
        ),
        actions: [_iconAddressCreate()],
      ),
      body: GetBuilder<ClientAddressListController>(
        builder: (value) =>
            Stack(children: [_textAddress(), _listAddress(context)]),
      ),
    );
  }

  Widget _listAddress(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: FutureBuilder(
        future: con.getAddress(),
        builder: (context, AsyncSnapshot<List<Address>> snapshot) {
          print('😈  ${snapshot.data}');
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                itemBuilder: (_, index) {
                  return _radioSelectorAddress(snapshot.data![index], index);
                },
              );
            } else {
              return Center(
                child: NoDataWidget(text: 'No hay ubicaciones guardadas.'),
              );
            }
          } else {
            return Center(child: NoDataWidget(text: 'Cargando direcciones...'));
          }
        },
      ),
    );
  }

  Widget _radioSelectorAddress(Address address, int index) {
    return GestureDetector(
      onTap: () {
        con.handleRadioValueChange(index);
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: index,
                  groupValue: con.radioValue.value,
                  onChanged: con.handleRadioValueChange,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.address ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        address.neighborhood ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _textAddress() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30),
      child: Text(
        "Elije donde recibir tu pedido",
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _iconAddressCreate() {
    return IconButton(
      onPressed: () => con.goToAddressCreate(),
      icon: const Icon(EvaIcons.plus, color: Colors.black),
    );
  }

  Widget _buttonNextPayment(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: CustomFilledButton(
        text: 'Ir a método de pago',
        onPressed: () => con.createOrderWithPayment(),
      ),
    );
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: CustomFilledButton(
        text: 'Pago contra entrega',
        onPressed: () => con.createOrder(),
      ),
    );
  }
}
