import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  User? get currentUser => supabaseClient.auth.currentUser;

  Future<AuthResponse> signInWithEmailAndPassword({
    String email = '',
    String password = '',
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AuthResponse> signUpWithEmailAndPassword({
    String email = '',
    String password = '',
    String name = '',
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        await supabaseClient.from("users").insert({
          'id': response.user!.id,
          'email': email,
          'name': name,
        });
      }
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    await supabaseClient.auth.resetPasswordForEmail(email);
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  Future<String?> getUserType() async {
    final user = currentUser;
    if (user == null) return null;

    final response =
        await supabaseClient
            .from("users")
            .select("role")
            .eq("id", user.id)
            .maybeSingle();

    if (response != null && response['role'] != null) {
      return response['role'] as String;
    }
    return null;
  }
}
