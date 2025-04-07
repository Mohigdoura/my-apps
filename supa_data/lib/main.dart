import 'package:flutter/material.dart';
import 'package:supa_data/note_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: "https://oyeikeovgxrxwtqxfzcl.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95ZWlrZW92Z3hyeHd0cXhmemNsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMwMzMzNDQsImV4cCI6MjA1ODYwOTM0NH0.V-J4zrRFx6Fdab_lhyifV6eYSy0fMKHJkmW35jM6Tmw",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: NotePage());
  }
}
