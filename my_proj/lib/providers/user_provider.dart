// Using Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_proj/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

final userRoleProvider = FutureProvider.autoDispose<String?>((ref) async {
  final user = ref.watch(authStateProvider).value?.session?.user;
  return user != null ? AuthService().getCurrentUserRole() : null;
});
