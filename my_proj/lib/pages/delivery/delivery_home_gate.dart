import 'package:flutter/material.dart';

class DeliveryHomeGate extends StatelessWidget {
  const DeliveryHomeGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Home')),
      body: Center(
        child: const Text(
          'Welcome to the Delivery Home Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
