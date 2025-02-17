import 'package:flutter/material.dart';
import '../model/restaurants_model.dart';

class RestoPage extends StatelessWidget {
  final RestorantsModel restaurant;

  const RestoPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        backgroundColor: restaurant.boxColor,
      ),
      body: Center(
        child: Text(
          'Welcome to the ${restaurant.name} Restaurant!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
