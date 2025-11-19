import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/src/pages/client/payments/status/client_payments_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientPaymentsStatusPage extends StatelessWidget {
  ClientPaymentStatusController con = Get.put(ClientPaymentStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _textFinishTransaction(),
          ],
        ),
      ),
    );
  }

  Widget _textFinishTransaction() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 15),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            con.mercadoPagoPayment.status == 'approved'
                ? Icon(Icons.check_circle, size: 100, color: Colors.green[200])
                : Icon(Icons.cancel, size: 100, color: Colors.red[200]),
            Text(
              "Transaccion terminada",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.amber,
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.30,
        left: 50,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 239, 239, 239),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15,
            offset: Offset(0, 0.75),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textTransactionDetail(),
            _textTransactionStatus(),
            _buttonCreate(context),
          ],
        ),
      ),
    );
  }

  Widget _textTransactionDetail() {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 30),
      child: Text(
        con.mercadoPagoPayment.status == 'approved'
            ? 'Tu orden fue procesada exitosamente usando ${con.mercadoPagoPayment.paymentMethodId?.toUpperCase()} **** ${con.mercadoPagoPayment.card?.lastFourDigits}'
            : 'Tu pago fue rechazado',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _textTransactionStatus() {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 30),
      child: Text(
        con.mercadoPagoPayment.status == 'approved'
            ? 'Mira el estado de tu compra en la seccion de mis pedidos'
            : con.errorMessage.value,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: CustomFilledButton(
        text: 'Finalizar compra',
        onPressed: () {
          con.finishShopping();
        },
      ),
    );
  }
}
