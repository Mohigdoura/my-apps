import 'package:flutter/material.dart';
import 'package:mohi_note_app/database/note_database.dart';
import 'package:mohi_note_app/models/note.dart';
import 'package:provider/provider.dart';

class NotePage extends StatefulWidget {
  final String? text;
  final Note? note;

  NotePage({super.key, required this.text, required this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text ?? "");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void saveNote() {
    final noteDatabase = context.read<NoteDatabase>();
    final text = controller.text.trim();

    if (text.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (widget.note == null) {
      // Creating a new note
      final newNote = controller.text;
      noteDatabase.addNote(newNote);
    } else {
      // Updating an existing note
      noteDatabase.updateNote(widget.note!.id, text);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 31, 31, 31),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'T I T L E :\n\nType your note...',
                ),
                maxLines: null,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: MaterialButton(
                      onPressed: saveNote,
                      child: const Text('Save', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: MaterialButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
