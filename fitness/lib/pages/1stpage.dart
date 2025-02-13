import 'package:fitness/pages/home.dart';
import 'package:flutter/material.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('welcome')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate to a new screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue,
            child:
                Text('Tap to continue', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
