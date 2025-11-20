import 'dart:convert';
import 'package:delivery_app/src/environment/environment.dart';
import 'package:delivery_app/src/models/mercado_pago_card_token.dart';
import 'package:delivery_app/src/models/mercado_pago_document_type.dart';
import 'package:delivery_app/src/models/mercado_pago_payment_method_installments.dart';
import 'package:delivery_app/src/models/order.dart';
import 'package:delivery_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MercadoPagoProvider {
  final String url = Environment.API_MERCADO_PAGO;
  late User userSession;

  MercadoPagoProvider() {
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      userSession = User.fromJson(jsonDecode(userJson));
    } else {
      userSession = User();
    }
  }

  Future<MercadoPagoPaymentMethodInstallments> getInstallment(
    String bin,
    double amount,
  ) async {
    final uri = Uri.parse(
      '$url/payment_methods/installments?bin=$bin&amount=$amount',
    );

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'Bearer ${Environment.MERCADO_PAGO_ACCESS_TOKEN}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return MercadoPagoPaymentMethodInstallments.fromJson(body[0]);
    } else if (response.statusCode == 401) {
      throw Exception('Tu usuario no tiene permitido leer esta información');
    } else {
      throw Exception('No se pudo obtener las cuotas de la tarjeta');
    }
  }

  Future<List<MercadoPagoDocumentType>> getIdentificationTypes() async {
    final uri = Uri.parse('$url/identification_types');

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'Bearer ${Environment.MERCADO_PAGO_ACCESS_TOKEN}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return MercadoPagoDocumentType.fromJsonList(body);
    } else if (response.statusCode == 401) {
      throw Exception('Tu usuario no tiene permitido leer esta información');
    } else {
      throw Exception('No se pudo obtener los tipos de identificación');
    }
  }

  Future<http.Response> createPayment({
    required String token,
    required String issuerId,
    required String paymentMethodId,
    required double transactionAmount,
    required String paymentTypeId,
    required String emailCustomer,
    required String identificationType,
    required String identificationNumber,
    required int installments,
    required Order order,
  }) async {
    await _loadUserSession();

    final uri = Uri.parse('${Environment.API_URL}api/payments/create');

    final body = jsonEncode({
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
      'order': order.toJson(),
    });

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'JWT ${userSession.token ?? ''}',
      },
      body: body,
    );

    return response;
  }

  Future<MercadoPagoCardToken> createCardToken({
    required String cvv,
    required String expirationYear,
    required int expirationMonth,
    required String cardNumber,
    required String cardHolderName,
    required String documentNumber,
    required String documentId,
  }) async {
    final uri = Uri.parse(
      '$url/card_tokens?public_key=${Environment.MERCADO_PAGO_PUBLIC_KEY}',
    );

    final body = jsonEncode({
      'security_code': cvv,
      'expiration_years': expirationYear,
      'expiration_month': expirationMonth,
      'card_number': cardNumber,
      'card_holder': {
        'name': cardHolderName,
        'identification': {'number': documentNumber, 'type': documentId},
      },
    });

    final response = await http.post(
      uri,
      headers: {"Content-Type": 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      return MercadoPagoCardToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('No se pudo validar la tarjeta');
    }
  }
}
