import 'package:delivery_app/components/common/custom_filled_button.dart';
import 'package:delivery_app/components/common/custom_text_form_field.dart';
import 'package:delivery_app/src/constants/app_colors.dart';
import 'package:delivery_app/src/models/mercado_pago_document_type.dart';
import 'package:delivery_app/src/pages/client/payments/create/client_payments_create_controller.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

class ClientPaymentsCreatePage extends StatelessWidget {
  ClientPaymentsCreateController con = Get.put(
    ClientPaymentsCreateController(),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text('Pagos')),
        bottomNavigationBar: _buttonNext(context),
        body: Stack(
          children: [
            ListView(
              children: [
                CreditCardWidget(
                  cardNumber: con.cardNumber.value,
                  expiryDate: con.expireDate.value,
                  cardHolderName: con.cardHolderName.value,
                  cvvCode: con.cvvCode.value,
                  showBackView: con.isCvvFocused.value,
                  onCreditCardWidgetChange: (CreditCardBrand brand) {},
                  bankName: '',
                  cardBgColor: Colors.black87,
                  enableFloatingCard: true,
                  floatingConfig: const FloatingConfig(
                    isGlareEnabled: true,
                    isShadowEnabled: true,
                    shadowConfig: FloatingShadowConfig(),
                  ),
                  backgroundImage: 'assets/card/card_bg.png',
                  labelValidThru: 'VENCE\nFIN DE',
                  obscureCardNumber: true,
                  obscureInitialCardNumber: false,
                  obscureCardCvv: true,
                  labelCardHolder: 'NOMBRE Y APELLIDO',
                  // cardType: CardType.visa,
                  isHolderNameVisible: true,
                  // height: 175,
                  // textStyle: TextStyle(color: Colors.yellowAccent),
                  width: MediaQuery.of(context).size.width,
                  isChipVisible: true,
                  isSwipeGestureEnabled: true,
                  animationDuration: Duration(milliseconds: 1000),
                  // frontCardBorder: Border.all(color: Colors.grey),
                  // backCardBorder: Border.all(color: Colors.grey),
                  padding: 16,

                  // glassmorphismConfig: Glassmorphism(
                  //   blurX: 10.0,
                  //   blurY: 10.0,
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //     colors: <Color>[
                  //       Colors.grey.withAlpha(50),
                  //       Colors.white.withAlpha(30),
                  //     ],
                  //     stops: const <double>[
                  //       0.3,
                  //       0,
                  //     ],
                  //   ),
                  // ),
                ),
                CreditCardForm(
                  formKey: con.keyForm,
                  obscureCvv: true,
                  obscureNumber: true,
                  cardNumber: '',
                  cvvCode: '',
                  cardHolderName: '',
                  expiryDate: '',
                  // isHolderNameVisible: true,
                  // isCardNumberVisible: true,
                  // isExpiryDateVisible: true,
                  inputConfiguration: const InputConfiguration(
                    cardNumberDecoration: InputDecoration(
                      suffixIcon: Icon(Icons.credit_card_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Numero de la tarjeta',
                      hintText: 'XXXX XXXX XXXX XXXX',
                    ),
                    expiryDateDecoration: InputDecoration(
                      suffixIcon: Icon(Icons.date_range_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Expiracion',
                      hintText: 'XX/XX',
                    ),
                    cvvCodeDecoration: InputDecoration(
                      suffixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    cardHolderDecoration: InputDecoration(
                      suffixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                      labelText: 'Titular de la tarjeta',
                    ),
                  ),
                  onCreditCardModelChange: con.onCreditCardModelChange,
                ),
                _dropDownWidget(con.documents),
                _textFieldDocument(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: CustomFilledButton(
        buttonColor: Colors.green,
        text: 'Continuar',
        onPressed: () => con.createCardToken(),
      ),
    );
  }

  List<DropdownMenuItem<String?>> _dropDownItems(
    List<MercadoPagoDocumentType> documents,
  ) {
    List<DropdownMenuItem<String>> list = [];
    documents.forEach((document) {
      list.add(
        DropdownMenuItem(child: Text(document.name ?? ''), value: document.id),
      );
    });
    return list;
  }

  Widget _dropDownWidget(List<MercadoPagoDocumentType> documents) {
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
          "Seleccionar tipo de documento",
          style: TextStyle(fontSize: 15),
        ),
        items: _dropDownItems(documents),
        value: con.idDocument.value == '' ? null : con.idDocument.value,
        onChanged: (option) {
          print('Opcion selecciona ${option} ');
          con.idDocument.value = option.toString();
        },
      ),
    );
  }

  Widget _textFieldDocument() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: TextField(
        controller: con.documentNumberController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Numero Documento',
        ),
      ),
    );
  }
}
