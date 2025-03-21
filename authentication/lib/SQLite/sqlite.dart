import 'package:authentication/JsonModels/note_model.dart';
import 'package:authentication/JsonModels/users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "note.db";

  String noteTable =
      "CREATE TABLE notes (noteId INTEGER PRIMARY KEY AUTOINCREMENT, noteTitle TEXT NOT NULL, noteContent TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  String users =
      "CREATE TABLE users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(users);
        await db.execute(noteTable);
      },
    );
  }

  // Login method
  Future<bool> login(Users user) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
      "SELECT * FROM users WHERE usrName = ? AND usrPassword = ?",
      [user.usrName, user.usrPassword],
    );
    return result.isNotEmpty;
  }

  // Sign up method
  Future<int> signup(Users user) async {
    final db = await initDB();
    var result = await db.query(
      'users',
      where: "usrName = ?",
      whereArgs: [user.usrName],
    );
    if (result.isNotEmpty) {
      throw Exception("Username already exists");
    }
    return await db.insert('users', user.toMap());
  }

  // Search method
  Future<List<NoteModel>> searchNotes(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db.rawQuery(
      "SELECT * FROM notes WHERE noteTitle LIKE ?",
      ["%$keyword%"],
    );
    return searchResult.map((e) => NoteModel.fromMap(e)).toList();
  }

  // Create note
  Future<int> createNote(NoteModel note) async {
    final Database db = await initDB();
    return await db.insert('notes', note.toMap());
  }

  // Get notes
  Future<List<NoteModel>> getNotes() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('notes');
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  // Delete note
  Future<int> deleteNote(int id) async {
    final Database db = await initDB();
    return await db.delete('notes', where: 'noteId = ?', whereArgs: [id]);
  }

  // Update note
  Future<int> updateNote(title, content, noteId) async {
    final Database db = await initDB();
    return await db.update(
      'notes',
      {'noteTitle': title, 'noteContent': content},
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
  }
}
