// Create a provider for the UserState
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_proj/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

// Create the notifier that will handle user authentication logic
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState.initial());
  final supabase = Supabase.instance.client;

  // Check if user is already logged in when app starts
  Future<void> checkCurrentUser() async {
    final currentUser = supabase.auth.currentUser;

    if (currentUser != null) {
      try {
        final profileData =
            await supabase
                .from('profiles')
                .select('role')
                .eq('id', currentUser.id)
                .single();

        state = state.copyWith(
          user: currentUser,
          role: profileData['role'],
          isAuthenticated: true,
        );
      } catch (e) {
        // Handle error fetching profile
      }
    }
  }

  // Sign in method
  Future<void> signIn(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final profileData =
            await supabase
                .from('profiles')
                .select('role')
                .eq('id', response.user!.id)
                .single();

        state = state.copyWith(
          user: response.user,
          role: profileData['role'],
          isLoading: false,
          isAuthenticated: true,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
    }
  }

  // Sign up method with role
  Future<void> signUp(String email, String password, String role) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await supabase.from('profiles').insert({
          'id': response.user!.id,
          'email': email,
          'role': role,
          'created_at': DateTime.now().toIso8601String(),
        });

        state = state.copyWith(
          user: response.user,
          role: role,
          isLoading: false,
          isAuthenticated: true,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      state = UserState.initial();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Get current user role
  String? get userRole => state.role;
}
