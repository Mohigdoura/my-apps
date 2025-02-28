import 'dart:ui';

import 'package:fitness/model/foodmodel.dart';
import 'package:flutter/material.dart';
import '../model/restaurants_model.dart';

class RestoPage extends StatelessWidget {
  final RestorantsModel restaurant;

  const RestoPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    List<FoodModel> foods = [];
    List<FoodModel> foods2 = [];
    foods = FoodModel.getFood();
    foods2 = foodpicker(restaurant);
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.asset(
                          foods2[index].iconPath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            color: Colors.white.withOpacity(0.2),
                            height: 40,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                foods2[index].name,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

List<FoodModel> foodpicker(RestorantsModel restaurant) {
  List<FoodModel> food = [];
  List<FoodModel> food2 = [];
  food = FoodModel.getFood();
  for (var i = 0; i < food.length; i++) {
    if (food[i].resto.contains(restaurant.name)) {
      food2.add(food[i]);
    }
  }
  return food2;
}
