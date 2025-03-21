import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/pages/foodpage.dart';
import 'package:fitness/pages/cartpage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Constants for reusable strings and colors
  static const String appTitle = 'Welcome';
  static const String foodPageTitle = 'Food Page';
  static const String ordersPageTitle = 'Orders';
  static const String profileTitle = 'Profile';
  static const Color foodButtonColor = Colors.orange;
  static const Color ordersButtonColor = Colors.blue;

  // List to store orders

  // Callback function to add orders

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(title: const Text(appTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircularButton(
              icon: Icons.fastfood,
              text: foodPageTitle,
              color: foodButtonColor,
              onTap: () => _navigateToPage(
                context,
                Foodpage(), // Pass the callback
              ),
            ),
            const SizedBox(height: 30),
            _buildCircularButton(
              icon: Icons.shopping_cart,
              text: ordersPageTitle,
              color: ordersButtonColor,
              onTap: () => _navigateToPage(
                context,
                Cartpage(), // Pass the orders list
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 30),
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.fastfood,
            title: foodPageTitle,
            onTap: () => _navigateToPage(
              context,
              Foodpage(), // Pass the callback
            ),
          ),
          _buildDrawerItem(
            icon: Icons.shopping_cart,
            title: ordersPageTitle,
            onTap: () => _navigateToPage(
              context,
              Cartpage(), // Pass the orders list
            ),
          ),
          signoutWithhGougle()
        ],
      ),
    );
  }

  IconButton signoutWithhGougle() {
    return IconButton(
      onPressed: () async {
        await GoogleSignIn().signOut();
        FirebaseAuth.instance.signOut();
      },
      icon: Icon(Icons.logout),
    );
  }

  // Build the drawer header
  Widget _buildDrawerHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(color: Colors.grey),
      child: Text(
        profileTitle,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Build a reusable drawer item
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }

  // Build a circular button
  Widget _buildCircularButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
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
          const SizedBox(height: 10), // Add spacing between the icon and text
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Navigate to a page with a custom transition
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).push(_createRoute(page));
  }

  // Create a custom route transition
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
