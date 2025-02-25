import 'package:fitness/model/foodmodel.dart';
import 'package:flutter/material.dart';
import '../model/restaurants_model.dart';

class RestoPage extends StatelessWidget {
  final RestorantsModel restaurant;

  const RestoPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    List<FoodModel> foods = [];
    foods = FoodModel.getFood();
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        backgroundColor: restaurant.boxColor,
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 150,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemCount: foodCounter(foods, restaurant),
          ),
        ],
      ),
    );
  }
}

int foodCounter(List<FoodModel> foods, RestorantsModel restaurant) {
  int k = 0;
  for (var i = 0; i < foods.length; i++) {
    if (foods[i].resto.contains(restaurant.name)) {
      k++;
    }
  }
  return k;
}
