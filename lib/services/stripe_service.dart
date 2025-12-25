import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripeService {
  static String get _publishableKey => dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static String get _secretKey => dotenv.env['STRIPE_SECRET_KEY'] ?? '';

  static Future<void> init() async {
    Stripe.publishableKey = _publishableKey;
  }

  static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (amount * 100).toInt().toString(), // Stripe utilise les centimes
          'currency': currency.toLowerCase(),
          'description': description,
          'automatic_payment_methods[enabled]': 'true',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur création PaymentIntent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur Stripe: $e');
    }
  }

  static Future<bool> processPayment({
    required double amount,
    required String currency,
    required String description,
  }) async {
    try {
      // 1. Créer PaymentIntent
      final paymentIntent = await createPaymentIntent(
        amount: amount,
        currency: currency,
        description: description,
      );

      // 2. Initialiser la feuille de paiement
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'PicknDream',
          style: ThemeMode.system,
        ),
      );

      // 3. Présenter la feuille de paiement
      await Stripe.instance.presentPaymentSheet();
      
      return true;
    } catch (e) {
      print('Erreur paiement Stripe: $e');
      return false;
    }
  }
}
