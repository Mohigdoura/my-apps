import 'package:flutter/material.dart';

class RestaurantHomeGate extends StatelessWidget {
  const RestaurantHomeGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Home')),
      body: Center(
        child: const Text(
          'Welcome to the Restaurant Home Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
