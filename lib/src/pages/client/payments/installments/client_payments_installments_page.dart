import 'package:delivery_app/src/models/mercado_pago_installment.dart';
import 'package:delivery_app/src/pages/client/payments/installments/client_payments_installments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientPaymentsInstallmentsPage extends StatelessWidget {
  ClientPaymentsInstallmentsController con = Get.put(
    ClientPaymentsInstallmentsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          height: 100,
          child: _totalToPay(context),
        ),
        appBar: AppBar(title: Text('Cuotas')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textDescription(),
            _dropDownWidget(con.mercadoPagoInstallments),
          ],
        ),
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      margin: EdgeInsets.all(30),
      child: Text(
        'En cuantas cuotas?',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  onPressed: () => con.createPayment(),
                  child: const Text('Confirmar pago'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String?>> _dropDownItems(
    List<MercadoPagoInstallment> installments,
  ) {
    List<DropdownMenuItem<String>> list = [];
    installments.forEach((installment) {
      list.add(
        DropdownMenuItem(
          child: Text('${installment.installments}'),
          value: '${installment.installments}',
        ),
      );
    });
    return list;
  }

  Widget _dropDownWidget(List<MercadoPagoInstallment> installments) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: const Icon(Icons.arrow_drop_down_circle, color: Colors.amber),
        ),
        elevation: 3,
        isExpanded: true,
        hint: const Text(
          "Seleccionar numero de cuotas",
          style: TextStyle(fontSize: 15),
        ),
        items: _dropDownItems(installments),
        value: con.installments.value == '' ? null : con.installments.value,
        onChanged: (option) {
          print('Opcion selecciona ${option} ');
          con.installments.value = option.toString();
        },
      ),
    );
  }
}
