import 'package:flutter/material.dart';
import 'package:shop/models/shoe.dart';

class Cart extends ChangeNotifier {
  List<Shoe> shoeShop = [
    Shoe(
      name: 'Zoom',
      price: '254',
      imagePath: 'assets/images/b18241c7-60bc-4f9c-a5d9-b14448c4d73a.jfif',
      description: 'yes we can',
    ),
    Shoe(
      name: 'Pc',
      price: '999',
      imagePath: 'assets/images/20d820aa-6ff3-4831-957f-25fe02270297.gif',
      description: "no you can't",
    ),
  ];
  List<Shoe> userCart = [];

  List<Shoe> getShoeList() {
    return shoeShop;
  }

  List<Shoe> getUserCart() {
    return userCart;
  }

  void addItemToCart(Shoe shoe) {
    userCart.add(shoe);
    notifyListeners();
  }

  void removeItemFromCart(Shoe shoe) {
    userCart.remove(shoe);
    notifyListeners();
  }
}
