import 'package:flutter/material.dart';

class LovedModel {
  String name;
  String iconPath;
  String price;
  Color boxColor;
  bool viewIsSelected;

  LovedModel(
      {required this.name,
      required this.iconPath,
      required this.price,
      required this.boxColor,
      this.viewIsSelected = false});

  static List<LovedModel> getLoved() {
    List<LovedModel> loved = [];

    loved.add(LovedModel(
        name: 'cake',
        iconPath: 'assets/icons/honey-pancakes.svg',
        price: '12DT',
        viewIsSelected: true,
        boxColor: Color(0xff9DCEFF)));

    loved.add(LovedModel(
        name: 'chicken',
        iconPath: 'assets/icons/canai-bread.svg',
        price: '10DT',
        viewIsSelected: false,
        boxColor: Color(0xffEEA4CE)));

    loved.add(LovedModel(
        name: 'potatos',
        iconPath: 'assets/icons/canai-bread.svg',
        price: '100DT',
        viewIsSelected: true,
        boxColor: Color(0xff9DCEFF)));

    return loved;
  }
}
