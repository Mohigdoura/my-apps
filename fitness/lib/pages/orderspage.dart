import 'package:fitness/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Orderspage extends StatefulWidget {
  const Orderspage({super.key});

  @override
  State<Orderspage> createState() => _OrderpageState();
}

class _OrderpageState extends State<Orderspage> {
  List<OrderModel> orders = [];
  void _getInitialInfo() {
    orders = OrderModel.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                width: 15,
              ),
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(orders[index].iconPath),
                        ),
                      ),
                      Text(
                        orders[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
