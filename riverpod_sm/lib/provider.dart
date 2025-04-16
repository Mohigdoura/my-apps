import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_sm/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Persistent Counter Provider
final userProvider = StateNotifierProvider<UserEdit, User>((ref) {
  return UserEdit();
});

// Save counter value
Future<void> saveUser(User user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', user.name);
  await prefs.setString('type', user.type);
  await prefs.setString('descrip', user.descrip);
}

// Get counter value
Future<User> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('name') ?? '';
  final type = prefs.getString('type') ?? '';
  final descrip = prefs.getString('descrip') ?? '';
  return User(name: name, type: type, descrip: descrip);
}

// Counter StateNotifier
class UserEdit extends StateNotifier<User> {
  UserEdit() : super(User(name: '', type: '', descrip: '')) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    state = await getUser();
  }

  void changeName(String name) {
    final updated = User(name: name, type: state.type, descrip: state.descrip);
    state = updated;
    saveUser(updated);
  }

  void changeType(String type) {
    final updated = User(name: state.name, type: type, descrip: state.descrip);
    state = updated;
    saveUser(updated);
  }

  void changeDescrip(String descrip) {
    final updated = User(name: state.name, type: state.type, descrip: descrip);
    state = updated;
    saveUser(updated);
  }
}
