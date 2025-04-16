import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mohi_note_app/components/my_drawer.dart';
import 'package:mohi_note_app/components/my_note_tile.dart';
import 'package:mohi_note_app/database/note_database.dart';
import 'package:mohi_note_app/models/note.dart';
import 'package:mohi_note_app/pages/note_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final noteDatabase = context.read<NoteDatabase>();
    noteDatabase.readNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotePage(note: null, text: null),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  GridView _buildBody() {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentnotes;
    return GridView.builder(
      padding: EdgeInsets.only(left: 25, right: 25, top: 10),
      itemCount: currentNotes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        final note = currentNotes[index];
        return MyNoteTile(
          onLongPress:
              () => showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text("Delete Note"),
                    content: Text("Are you sure you want to delete this note?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.read<NoteDatabase>().deleteNote(note.id);
                          Navigator.pop(context);
                        },
                        child: Text("Delete"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  );
                },
              ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotePage(note: note, text: note.text),
              ),
            );
          },
          text: title_Note(note.text),
        );
      },
    );
  }

  String title_Note(String text) {
    for (var i = 0; i < min(text.length, 10); i++) {
      if (text[i] == '\n') {
        return text.substring(0, i);
      } else if (text[i] == ' ') {
        if (text.substring(0, i).length < 5) {
          continue;
        } else {
          return text.substring(0, i);
        }
      }
    }
    return text.substring(0, min(text.length, 10));
  }
}
