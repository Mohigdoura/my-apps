import 'package:fitness/pages/foodpage.dart';
import 'package:fitness/pages/orderspage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 30),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: Text('profile'),
            ),
            ListTile(
              title: Text('foodpage'),
              onTap: () {
                Navigator.of(context).push(_createRoute(Foodpage()));
              },
            ),
            ListTile(
              title: Text(
                'orders',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.of(context).push(_createRoute(Orderspage()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(title: Text('welcome')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(),
          GestureDetector(
            onTap: () {
              // Navigate to a new screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Foodpage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue,
              child: Text('Food', style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Orderspage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue,
              child: Text('Orders', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}

Route _createRoute(pagename) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pagename,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
