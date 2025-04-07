import 'package:chat_app/services/auth/login_or_register.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(); // Replace with your home page widget
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error occurred"));
          } else {
            return const LoginOrRegister(); // Replace with your login/register page widget
          }
        },
      ),
    );
  }
}
