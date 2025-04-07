import 'package:supa_data/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDatabase {
  // Database -> notes
  final database = Supabase.instance.client.from('notes');

  //create
  Future createNote(Note newNote) async {
    await database.insert(newNote.toMap());
  }

  // Read
  final stream = Supabase.instance.client
      .from('notes')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false)
      .map((data) => data.map((noteMap) => Note.fromMap(noteMap)).toList());

  // Update
  Future updateNote(Note oldNote, String newContent) async {
    await database.update({'content': newContent}).eq('id', oldNote.id!);
  }

  // Delete
  Future deleteNote(Note note) async {
    await database.delete().eq('id', note.id!);
  }
}
