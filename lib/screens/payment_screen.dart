// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guest_ms/screens/rooms.dart';
import 'package:guest_ms/services/api.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatelessWidget {
  final String room;
  final int days;
  final double amount;

  PaymentPage(this.room, this.days, this.amount, {super.key});

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  void makePayment(BuildContext context) async {
    final response = await http.post(
      Uri.parse(ApiServices().baseUrl + ApiServices().bookRoom),
      body: {
        'room': room,
        'days': days.toString(),
        'amount': amount.toString(),
        'card_number': cardNumberController.text,
        'expiry_date': expiryDateController.text,
        'cvv': cvvController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final password = data['password'];

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PasswordPage(password, data['expiry_time'])),
      );
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Room: $room'),
            Text('Days: $days'),
            Text('Amount: \$$amount'),
            TextField(
              controller: cardNumberController,
              decoration: const InputDecoration(labelText: 'Card Number'),
            ),
            TextField(
              controller: expiryDateController,
              decoration: const InputDecoration(labelText: 'Expiry Date'),
            ),
            TextField(
              controller: cvvController,
              decoration: const InputDecoration(labelText: 'CVV'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => makePayment(context),
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
