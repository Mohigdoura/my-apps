import 'package:flutter/material.dart';
import 'package:supa_data/note.dart';
import 'package:supa_data/note_database.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // note db
  final notesDatabase = NoteDatabase();

  final noteController = TextEditingController();

  void addNewNote() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('New Note'),
            content: TextField(controller: noteController),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  noteController.clear();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final newNote = Note(content: noteController.text);
                  notesDatabase.createNote(newNote);
                  Navigator.pop(context);
                  noteController.clear();
                },
                child: Text('Save'),
              ),
            ],
          ),
    );
  }

  void updateNote(Note note) {
    noteController.text = note.content;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Update Note'),
            content: TextField(controller: noteController),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  noteController.clear();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  notesDatabase.updateNote(note, noteController.text);
                  Navigator.pop(context);
                  noteController.clear();
                },
                child: Text('Save'),
              ),
            ],
          ),
    );
  }

  void deleteNote(Note note) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Note?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  notesDatabase.deleteNote(note);
                  Navigator.pop(context);
                },
                child: Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Notes'))),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: notesDatabase.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;
          if (notes.isEmpty) {
            return Center(child: Text('There is no note!'));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.content),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => updateNote(note),
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => deleteNote(note),
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
