import 'package:dark_light_mode/pages/homepage.dart';
import 'package:dark_light_mode/riverpod_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData themeData = ref.watch(riverpopTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: themeData,
    );
  }
}
