import 'package:auth_test/services/auth/auth_service.dart';
import 'package:auth_test/services/provider/auth_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthStates>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

class AuthNotifier extends StateNotifier<AuthStates> {
  final AuthService authService;
  AuthNotifier(this.authService) : super(AuthStates.loading()) {
    _init();
  }

  Future<void> _init() async {
    authService.supabaseClient.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        final userType = await authService.getUserType();
        state = AuthStates.loggedIn(userType ?? 'client');
      } else {
        state = AuthStates.loggedOut();
      }
    });

    // Initial check if already logged in
    if (authService.currentUser != null) {
      final userType = await authService.getUserType();
      state = AuthStates.loggedIn(userType ?? 'client');
    } else {
      state = AuthStates.loggedOut();
    }
  }

  // SIGN IN
  Future<String?> signIn(String email, String password) async {
    state = AuthStates.loading();
    try {
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userType = await authService.getUserType();
      state = AuthStates.loggedIn(userType ?? 'client');
      return null; // no error
    } catch (e) {
      state = AuthStates.loggedOut();
      return e.toString(); // return error message to show in UI
    }
  }

  // SIGN UP
  Future<String?> signUp(String email, String password, String name) async {
    state = AuthStates.loading();
    try {
      await authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );

      final userType = await authService.getUserType();
      state = AuthStates.loggedIn(userType ?? 'client');
      return null;
    } catch (e) {
      state = AuthStates.loggedOut();
      return e.toString();
    }
  }

  Future<User?> getUser() async {
    return authService.currentUser!;
  }

  Future<void> signOut() async {
    await authService.signOut();
    state = AuthStates.loggedOut();
  }
}
