import 'package:flutter/material.dart';

class CustomerHomeGate extends StatelessWidget {
  const CustomerHomeGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Home')),
      body: Center(
        child: const Text(
          'Welcome to the Customer Home Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
