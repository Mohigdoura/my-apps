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
          padding: const EdgeInsets.only(top: 30),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: Text('Profile',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.blue),
              title: const Text('Food Page'),
              onTap: () {
                Navigator.of(context).push(_createRoute(const Foodpage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.blue),
              title: const Text('Orders'),
              onTap: () {
                Navigator.of(context).push(_createRoute(const Orderspage()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircularButton(
              icon: Icons.fastfood,
              text: 'Food',
              color: Colors.orange,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Foodpage()));
              },
            ),
            const SizedBox(height: 30),
            _buildCircularButton(
              icon: Icons.shopping_cart,
              text: 'Orders',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Orderspage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton(
      {required IconData icon,
      required String text,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipOval(
            child: Container(
              width: 80,
              height: 80,
              color: color,
              child: Icon(icon, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 10),
          Text(text,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

Route _createRoute(Widget pagename) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pagename,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
