import 'package:flutter/material.dart';

class RestorantsModel {
  String name;
  String iconPath;
  Color boxColor;
  RestorantsModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });
  static List<RestorantsModel> getRestaurants() {
    List<RestorantsModel> restaurants = [];
    restaurants.add(RestorantsModel(
        name: 'la casa',
        iconPath: 'assets/icons/plate.svg',
        boxColor: Color(0xff9DCEFF)));

    restaurants.add(RestorantsModel(
        name: 'marella',
        iconPath: 'assets/icons/pancakes.svg',
        boxColor: Color(0xffEEA4CE)));

    restaurants.add(RestorantsModel(
        name: 'abd rhim',
        iconPath: 'assets/icons/pie.svg',
        boxColor: Color(0xff9DCEFF)));

    restaurants.add(RestorantsModel(
        name: 'mdnini',
        iconPath: 'assets/icons/orange-snacks.svg',
        boxColor: Color(0xffEEA4CE)));
    return restaurants;
  }
}
