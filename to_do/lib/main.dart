import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/models/note_database.dart';
import 'package:to_do/pages/notes_page.dart';

void main() async {
  //initialize note isar db
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.intialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => NoteDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: NotesPage());
  }
}
