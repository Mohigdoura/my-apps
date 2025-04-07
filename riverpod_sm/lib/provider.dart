import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Persistent Counter Provider
final counterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter();
});

// Save counter value
Future<void> saveCounter(int value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', value);
}

// Get counter value
Future<int> getCounter() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('counter') ?? 0;
}

// Counter StateNotifier
class Counter extends StateNotifier<int> {
  Counter() : super(0) {
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    state = await getCounter();
  }

  void increment() {
    state++;
    saveCounter(state);
  }

  void decrement() {
    state--;
    saveCounter(state);
  }

  void reset() {
    state = 0;
    saveCounter(state);
  }
}
