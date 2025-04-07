// First, create a UserState class to hold all user-related data
import 'package:supabase_flutter/supabase_flutter.dart';

class UserState {
  final User? user; // Supabase User object
  final String? role; // 'admin', 'restaurant', 'delivery', 'customer'
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  // Constructor
  UserState({
    this.user,
    this.role,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  // Initial state factory constructor
  factory UserState.initial() {
    return UserState(
      user: null,
      role: null,
      isLoading: false,
      isAuthenticated: false,
      error: null,
    );
  }

  // Copy with method to create a new instance with some values changed
  UserState copyWith({
    User? user,
    String? role,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
    );
  }
}
