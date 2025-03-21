import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cartItem.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/shoe.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder:
          (context, value, child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Cart',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: value.getUserCart().length,
                    itemBuilder: (context, index) {
                      Shoe individualShoe = value.getUserCart()[index];

                      return CartItem(shoe: individualShoe);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
