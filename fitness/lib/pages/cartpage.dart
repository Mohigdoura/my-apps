import 'package:fitness/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'foodpage.dart'; // Make sure to import the Foodpage

class Cartpage extends StatefulWidget {
  final List<CartModel> orders;

  const Cartpage({super.key, required this.orders});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Button to navigate to Foodpage
          _buildGoToFoodPageButton(),
          const SizedBox(height: 16),

          // List of orders
          Expanded(
            child: _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  // Build the app bar
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          SizedBox(
            width: 110,
          ),
          const Text(
            'Cart',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
    );
  }

  // Build the "Go to Food Page" button
  Widget _buildGoToFoodPageButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Foodpage(
                onAddToOrders: (newOrder) {
                  setState(() {
                    // Check if item already exists
                    int existingIndex = widget.orders
                        .indexWhere((order) => order.name == newOrder.name);
                    if (existingIndex != -1) {
                      // If exists, increment count
                      widget.orders[existingIndex].number++;
                    } else {
                      // If not, add new item
                      widget.orders.add(newOrder);
                    }
                  });
                },
              ),
            ),
          );
        },
        child: const Text('Go to Food Page'),
      ),
    );
  }

  // Build the list of orders
  Widget _buildOrdersList() {
    return ListView.separated(
      itemCount: widget.orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 5),
      itemBuilder: (context, index) {
        return _buildOrderItem(index);
      },
    );
  }

  // Build an individual order item
  Widget _buildOrderItem(int index) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.07),
            offset: const Offset(0, 10),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Order icon
          SvgPicture.asset(
            widget.orders[index].iconPath,
            width: 65,
            height: 65,
          ),

          // Order details (name and price)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.orders[index].name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                widget.orders[index].price,
                style: const TextStyle(
                    color: Color(0xff7B6F72),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),

          // Quantity controls (plus and minus buttons)
          Column(
            children: [
              const SizedBox(height: 35),
              Row(
                children: [
                  // Minus button
                  GestureDetector(
                    onTap: () => _decrementItemCount(index),
                    child: SvgPicture.asset(
                      'assets/icons/minus-line-svgrepo-com.svg',
                      width: 15,
                      height: 15,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Quantity display
                  Text(
                    '${widget.orders[index].number}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(width: 10),

                  // Plus button
                  GestureDetector(
                    onTap: () => _incrementItemCount(index),
                    child: SvgPicture.asset(
                      'assets/icons/icons8-plus.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to increment the quantity of an order item
  void _incrementItemCount(int index) {
    setState(() {
      widget.orders[index].number++;
    });
  }

  // Method to decrement the quantity of an order item
  void _decrementItemCount(int index) {
    setState(() {
      if (widget.orders[index].number > 1) {
        widget.orders[index].number--;
      } else {
        // Remove the item if the quantity reaches zero
        widget.orders.removeAt(index);
      }
    });
  }
}
