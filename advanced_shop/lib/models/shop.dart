import 'package:advanced_shop/models/product.dart';
import 'package:flutter/material.dart';

class Shop extends ChangeNotifier {
  // products
  final List<Product> _shop = [
    Product(
      name: 'product 1',
      price: 99.99,
      description: 'very good thing to buy',
      imagePath: 'assets/images/WhatsApp Image 2025-02-22 at 10.20.56 PM.jpeg',
    ),
    Product(
      name: 'product 2',
      price: 999.99,
      description: 'very good nigga to buy',
      imagePath: 'assets/images/WhatsApp Image 2025-02-22 at 10.25.08 PM.jpeg',
    ),
    Product(
      name: 'product 3',
      price: 59.99,
      description: 'very good slave to buy',
      imagePath:
          'assets/images/WhatsApp Image 2025-02-23 at 12.42.22 AM (1).jpeg',
    ),
  ];

  //user cart
  final List<Product> _cart = [];

  //get product list
  List<Product> get shop => _shop;

  //get user cart
  List<Product> get cart => _cart;

  //add item to cart
  void addToCart(Product item) {
    _cart.add(item);
    notifyListeners();
  }

  // remove item from cart
  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners();
  }
}
