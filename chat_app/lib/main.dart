import 'package:chat_app/database/user_settings.dart';
import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isDarkMode = ref.watch(userSettingsProvider).isDarkMode;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthGate(),
          theme: isDarkMode ? darkMode : lightMode,
          routes: // Define your routes here
              {'/settings': (context) => SettingsPage()},
        );
      },
    );
  }
}
