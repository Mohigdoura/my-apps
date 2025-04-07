import 'package:flutter/material.dart';
import 'package:profile_management/services/auth/auth_gate.dart';
import 'package:profile_management/services/auth/auth_service.dart';
import 'package:profile_management/pages/profile_edit.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final authService = AuthService();
  String nameText = " ";

  void fetchUserName() async {
    try {
      final userName = await authService.getCurrentUserName();
      if (userName != null) {
        setState(() {
          nameText = userName;
        });
      }
    } catch (e) {
      setState(() {
        nameText = "Error fetching name";
      });
    }
  }

  void logout() {
    authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthGate()),
    );
  }

  String emailText() {
    return authService.getCurrentUserEmail().toString();
  }

  @override
  void initState() {
    fetchUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                nameText.substring(0, 1).toUpperCase(),
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          Center(child: Text(emailText())),
                        ],
                      ),
                      Text(
                        nameText.toUpperCase(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileEdit()),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 25),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
