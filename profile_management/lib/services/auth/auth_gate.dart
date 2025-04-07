import 'package:flutter/material.dart';
import 'package:profile_management/pages/home_gate.dart';
import 'package:profile_management/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // List to auth state chaneges
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // Build appropriate page based on auth state
      builder: (context, snapshot) {
        // Loiding//
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // check if there is valid session currenty
        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session != null) {
          return const HomeGate();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
