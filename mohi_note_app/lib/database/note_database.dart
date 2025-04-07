import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mohi_note_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  final List<Note> currentnotes = [];

  Future<void> addNote(String note) async {
    final newNote = Note()..text = note;
    await isar.writeTxn(() => isar.notes.put(newNote));
    readNotes();
  }

  Future<void> readNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentnotes.clear();
    currentnotes.addAll(fetchedNotes);
    notifyListeners();
  }

  Future<void> updateNote(int id, String newNote) async {
    final note = await isar.notes.get(id);
    if (note != null) {
      await isar.writeTxn(() async {
        note.text = newNote;
        isar.notes.put(note);
      });
    }
    readNotes();
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async {
      await isar.notes.delete(id);
    });
    readNotes();
  }
}
