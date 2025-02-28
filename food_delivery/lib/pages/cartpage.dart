import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'foodpage.dart'; // Make sure to import the Foodpage

class Cartpage extends StatefulWidget {
  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  final FirestoreService firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getOrdersStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List ordersList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: ordersList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = ordersList[index];
                  String docId = document.id;
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String orderText = data['orderName'];
                  return ListTile(
                    title: Text(orderText),
                    trailing: IconButton(
                      onPressed: () => firestoreService.deleteOrder(docId),
                      icon: Icon(Icons.delete),
                    ),
                  );
                },
              );
            } else
              return Text('no orders');
          },
        ));
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
              builder: (context) => Foodpage(),
            ),
          );
        },
        child: const Text('Go to Food Page'),
      ),
    );
  }

  // Build the list of orders
}
