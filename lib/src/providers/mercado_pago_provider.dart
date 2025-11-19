import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/mercado_pago_card_token.dart';
import 'package:delivery_app/src/models/mercado_pago_document_type.dart';
import 'package:delivery_app/src/models/mercado_pago_payment_method.dart';
import 'package:delivery_app/src/models/mercado_pago_payment_method_installments.dart';
import 'package:delivery_app/src/models/order.dart';
import 'package:delivery_app/src/models/response_api.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MercadoPagoProvider extends GetConnect {
  String url = Environment.API_MERCADO_PAGO;
  // String url = Environment.API_URL;

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<MercadoPagoPaymentMethodInstallments> getInstallment(
    String bin,
    double amount,
  ) async {
    Response response = await get(
      '$url/payment_methods/installments',
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'Bearer ${Environment.MERCADO_PAGO_ACCESS_TOKEN}',
      },
      query: {'bin': bin, 'amount': '${amount}'},
    );

    print('-----------------getInstallment----------------');
    print('🍓response ${response} ');
    print('🍓response statuscode ${response.statusCode} ');
    print('🍓response body ${response.body} ');

    if (response.statusCode == 401) {
      Get.snackbar(
        'Peticion rechazada',
        'Tu usuario no tiene permitido leer esta información',
      );
      return MercadoPagoPaymentMethodInstallments();
    }
    if (response.statusCode != 200) {
      Get.snackbar(
        'Peticion rechazada',
        'No se pudo obtener las cuotas de la tarjeta',
      );
      return MercadoPagoPaymentMethodInstallments();
    }

    MercadoPagoPaymentMethodInstallments data =
        MercadoPagoPaymentMethodInstallments.fromJson(response.body[0]);

    return data;
  }

  Future<List<MercadoPagoDocumentType>> getIdentificationTypes() async {
    Response response = await get(
      '$url/identification_types',
      headers: {
        "Content-type": 'application/json',
        "Authorization": 'Bearer ${Environment.MERCADO_PAGO_ACCESS_TOKEN}',
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar(
        'Peticion rechazada',
        'Tu usuario no tiene permitido leer esta información',
      );
      return [];
    }
    print('-----------------getIdentificationTypes----------------');
    print('🍓response ${response} ');
    print('🍓response statuscode ${response.statusCode} ');
    print('🍓response body ${response.body} ');

    List<MercadoPagoDocumentType> documents =
        MercadoPagoDocumentType.fromJsonList(response.body);
    return documents;
  }

  Future<Response> createPayment({
    @required String? token,
    @required String? issuerId,
    @required String? paymentMethodId,
    @required double? transactionAmount,
    @required String? paymentTypeId,
    @required String? emailCustomer,
    @required String? identificationType,
    @required String? identificationNumber,
    @required int? installments,
    @required Order? order,
  }) async {
    Response response = await post(
      '${Environment.API_URL}api/payments/create',
      {
        'token': token,
        'issuer_id': issuerId,
        'payment_method_id': paymentMethodId,
        'transaction_amount': transactionAmount,
        'installments': installments,
        'payer': {
          'email': emailCustomer,
          'identification': {
            'type': identificationType,
            'number': identificationNumber,
          },
        },
        'order': order!.toJson(),
      },

      headers: {
        "Content-type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
      // query: {
      //   'public_key': Environment.MERCADO_PAGO_PUBLIC_KEY,
      // },
    );
    print('-----------------createPayment----------------');
    print('🍓response ${response} ');
    print('🍓response statuscode ${response.statusCode} ');
    print('🍓response body ${response.body} ');

    return response;
  }

  Future<MercadoPagoCardToken> createCardToken({
    String? cvv,
    String? expirationYear,
    int? expirationMonth,
    String? cardNumber,
    String? cardHolderName,
    String? documentNumber,
    String? documentId,
  }) async {
    Response response = await post(
      '$url/card_tokens?public_key=${Environment.MERCADO_PAGO_PUBLIC_KEY}',
      {
        'security_code': cvv,
        'expiration_years': expirationYear,
        'expiration_month': expirationMonth,
        'card_number': cardNumber,
        'card_holder': {
          'name': cardHolderName,
          'identification': {'number': documentNumber, 'type': documentId},
        },
      },
      headers: {"Content-type": 'application/json'},
      // query: {
      //   'public_key': Environment.MERCADO_PAGO_PUBLIC_KEY,
      // },
    );

    if (response.statusCode != 201) {
      Get.snackbar('Error', 'No se pudo validar la tarjeta');
      return MercadoPagoCardToken();
    }

    print('-----------------createCardToken----------------');
    print('🍓response ${response} ');
    print('🍓response statuscode ${response.statusCode} ');
    print('🍓response body ${response.body} ');

    MercadoPagoCardToken res = MercadoPagoCardToken.fromJson(response.body);
    return res;
  }
}
