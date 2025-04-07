import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  User? currentUser;

  AuthService() {
    currentUser = _supabaseClient.auth.currentUser;
  }

  // Sign in with email and password

  Future<String?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        final profileData =
            await _supabaseClient
                .from('users')
                .select('role')
                .eq('id', response.user!.id)
                .single();

        return profileData['role'];
      }
      return null;
    } on Exception catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  // Sign up with email and password

  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
    String role = 'customer',
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _supabaseClient.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'role': role,
        });
      }
      return response;
    } on Exception catch (e) {
      throw Exception('Error signing up: $e');
    }
  }

  Future<void> resestPassword(String email) async {
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }

  // Sign out
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  // Get user email
  String? getCurrentUserEmail() {
    final email = currentUser?.email;
    return email;
  }

  Future<String?> getCurrentUserName() async {
    final response =
        await _supabaseClient
            .from('users')
            .select('name')
            .eq('id', currentUser!.id.toString())
            .maybeSingle();

    if (response != null && response['name'] != null) {
      return response['name'] as String;
    }
    return null;
  }

  Future<void> changeUserName(String userName) async {
    await _supabaseClient
        .from('users')
        .update({'name': userName})
        .eq('id', currentUser!.id.toString());
  }

  Future<String?> getCurrentUserRole() async {
    if (_supabaseClient.auth.currentUser == null) return null;
    final res =
        await _supabaseClient
            .from('users')
            .select('role')
            .eq('id', _supabaseClient.auth.currentUser!.id)
            .maybeSingle();
    return res != null ? res['role'] : null;
  }
}
