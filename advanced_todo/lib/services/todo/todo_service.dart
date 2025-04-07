import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoService {
  // get a collerction of notes
  final CollectionReference todos = FirebaseFirestore.instance.collection(
    "todos",
  );

  // create
  Future<void> addTodo(String todo, String type) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return todos.add({
      'todo': todo,
      'userId': userId,
      'timestamp': Timestamp.now(),
      'type': type,
    });
  }

  // read
  Stream<QuerySnapshot> getTodosStream({String? type}) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Stream.empty(); // Prevents querying when user is not logged in
    }

    Query query = todos.where('userId', isEqualTo: userId);

    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }

    // ✅ This orderBy is required!
    query = query.orderBy('timestamp', descending: true);

    return query.snapshots();
  }

  // update
  Future<void> updateTodo(String docId, String newTodo, String newType) {
    return todos.doc(docId).update({'todo': newTodo, 'type': newType});
  }

  // delete
  Future<void> deleteTodo(String docId) {
    return todos.doc(docId).delete();
  }
}
