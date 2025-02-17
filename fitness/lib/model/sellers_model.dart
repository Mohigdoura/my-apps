import 'package:flutter/material.dart';

class SellersModel {
  String name;
  String iconPath;
  String price;
  Color boxColor;
  bool viewIsSelected;

  SellersModel(
      {required this.name,
      required this.iconPath,
      required this.price,
      required this.boxColor,
      this.viewIsSelected = false});

  static List<SellersModel> getSellers() {
    List<SellersModel> loved = [];

    loved.add(SellersModel(
        name: 'just a bread',
        iconPath: 'assets/icons/honey-pancakes.svg',
        price: '12DT',
        viewIsSelected: true,
        boxColor: Color(0xff9DCEFF)));

    loved.add(SellersModel(
        name: 'niggas food',
        iconPath: 'assets/icons/canai-bread.svg',
        price: '10DT',
        viewIsSelected: false,
        boxColor: Color(0xffEEA4CE)));

    loved.add(SellersModel(
        name: 'potatos',
        iconPath: 'assets/icons/canai-bread.svg',
        price: '100DT',
        viewIsSelected: true,
        boxColor: Color(0xff9DCEFF)));

    return loved;
  }
}
