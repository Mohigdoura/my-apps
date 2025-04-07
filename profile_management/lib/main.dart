import 'package:flutter/material.dart';
import 'package:profile_management/services/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      authOptions: FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        // Disable deep linking explicitly
        detectSessionInUri: false,
      ),
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlvdGV0aW5jY2l2a2tyaGVzdWFxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMwMDA3NTQsImV4cCI6MjA1ODU3Njc1NH0.NO3QnC_N91A4vvzEl77jLuX8TB4EgqffkX-hVVb8iu0",
      url: "https://iotetinccivkkrhesuaq.supabase.co",
      // Disable deep linking
    );
    print("Supabase initialized successfully");
  } catch (e) {
    print("Error initializing Supabase: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthGate());
  }
}
