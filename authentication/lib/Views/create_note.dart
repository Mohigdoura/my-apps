import 'package:authentication/JsonModels/note_model.dart';
import 'package:authentication/SQLite/sqlite.dart';
import 'package:flutter/material.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final title = TextEditingController();
  final content = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  Future<void> saveNote() async {
    if (formkey.currentState!.validate()) {
      try {
        await db.createNote(
          NoteModel(
            noteTitle: title.text,
            noteContent: content.text,
            createdAt: DateTime.now().toIso8601String(),
          ),
        );

        if (!mounted) return;
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to save note: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create note'),
        actions: [
          IconButton(onPressed: saveNote, icon: const Icon(Icons.check)),
        ],
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: title,
                validator:
                    (value) => value!.isEmpty ? "Title is required" : null,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: content,
                validator:
                    (value) => value!.isEmpty ? "Content is required" : null,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
