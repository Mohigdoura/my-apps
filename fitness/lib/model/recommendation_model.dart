import 'package:fitness/model/cart_model.dart';
import 'package:fitness/model/loved_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecommendationItem extends StatelessWidget {
  final LovedModel food;
  final void Function(CartModel) onAddToOrders;

  const RecommendationItem({
    super.key,
    required this.food,
    required this.onAddToOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: food.boxColor.withOpacity(0.3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              height: 80, width: 80, child: SvgPicture.asset(food.iconPath)),
          Column(
            children: [
              Text(
                food.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                food.price,
                style: const TextStyle(
                  color: Color(0xff786F72),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              CartModel newOrder = CartModel(
                name: food.name,
                price: food.price, // Example price
                iconPath: food.iconPath,
                number: 1, // Start with 1 quantity
              );

              onAddToOrders(newOrder);
            },
            child: Container(
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    food.viewIsSelected
                        ? const Color(0xff9DCEFF)
                        : const Color.fromARGB(171, 237, 133, 225),
                    food.viewIsSelected
                        ? const Color(0xff92A3FD)
                        : const Color.fromARGB(146, 247, 0, 255),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  'Add',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
