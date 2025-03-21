import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/models/note_database.dart';
import 'package:to_do/pages/notes_page.dart';
import 'package:to_do/theme/theme_provider.dart';

void main() async {
  //initialize note isar db
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();
  runApp(
    MultiProvider(
      providers: [
        //note provider
        ChangeNotifierProvider(
          create: (context) => NoteDatabase(),
          child: const MyApp(),
        ),
        //theme provider
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: const MyApp(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
