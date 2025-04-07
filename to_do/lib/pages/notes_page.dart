import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do/components/drawer.dart';
import 'package:to_do/components/note_tile.dart';
import 'package:to_do/models/note.dart';
import 'package:to_do/models/note_database.dart';
import 'package:to_do/theme/theme_provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  // Create a new note
  void createNote() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text("Add Note"),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Enter your note',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    context.read<NoteDatabase>().addNote(textController.text);
                  }
                  textController.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  "Create",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  textController.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // Read notes from the database
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // Update an existing note
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text("Update Note"),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    context.read<NoteDatabase>().updateNote(
                      note.id,
                      textController.text,
                    );
                  }
                  textController.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  textController.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // Delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: createNote,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Padding(
              padding: const EdgeInsets.only(left: 9.0),
              child: Text(
                'Notes',
                style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),

            // List of Notes
            Expanded(
              child:
                  currentNotes.isEmpty
                      ? Center(child: Text("No notes yet! Add some."))
                      : ListView.builder(
                        itemCount: currentNotes.length,
                        itemBuilder: (context, index) {
                          final note = currentNotes[index];
                          return NoteTile(
                            text: note.text,
                            onEditPressed: () => updateNote(note),
                            onDeletePressed: () => deleteNote(note.id),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
