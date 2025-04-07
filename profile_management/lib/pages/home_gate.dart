import 'package:flutter/material.dart';
import 'package:profile_management/pages/home_page.dart';
import 'package:profile_management/pages/name_register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeGate extends StatefulWidget {
  const HomeGate({super.key});

  @override
  State<HomeGate> createState() => _HomeGateState();
}

class _HomeGateState extends State<HomeGate> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchUserData() async {
    final response =
        await _supabaseClient
            .from('users')
            .select()
            .eq('id', _supabaseClient.auth.currentUser!.id.toString())
            .maybeSingle();

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // Show loading
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final userData = snapshot.data;

        if (userData != null &&
            userData['name'] != null &&
            userData['name'].isNotEmpty &&
            userData['phone'] != null &&
            userData['phone'].isNotEmpty) {
          return HomePage();
        }

        return NameRegisterPage();
      },
    );
  }
}
