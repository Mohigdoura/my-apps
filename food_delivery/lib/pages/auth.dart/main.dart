import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});
  @override
  State<Authentication> createState() => _Authenticationpage();
}

class _Authenticationpage extends State<Authentication> {
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Background Image that changes smoothly
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_isDrawerOpen
                          ? 'assets/icons/cake.jpg' // Change to your open drawer background
                          : 'assets/icons/jwajim.jpg' // Change to your closed drawer background
                      ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Center Button to Open Bottom Sheet
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _isDrawerOpen = true);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => buildBottomSheet(),
                  ).whenComplete(() => setState(() => _isDrawerOpen = false));
                },
                child: Text("Open Drawer"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200], // Background color
              borderRadius: BorderRadius.circular(30), // Rounded edges
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none, // No border
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 390,
            height: 60,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[900],
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Sign In",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Forgot password?',
              style: TextStyle(color: Colors.indigo[900]),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 20,
            child: Center(
              child: Text(
                '---------------------------------------------',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          SizedBox(
            height: 30,
            child: Center(
                child: Text(
              'or',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            )),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.grey[50]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 5,
                  children: [Icon(Icons.fmd_bad), Text('Sign In')],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.grey[50]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.g_mobiledata,
                      size: 30,
                    ),
                    Text('Sign In'),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 130),
        ],
      ),
    );
  }
}
