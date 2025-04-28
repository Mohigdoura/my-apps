import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to expose the welcome screen status
final welcomeProvider = NotifierProvider<WelcomeNotifier, bool>(() {
  return WelcomeNotifier();
});

// Loader provider to handle the initial async loading
final welcomeInitializerProvider = FutureProvider<bool>((ref) async {
  return await WelcomeService.hasSeenWelcome();
});

// Service class to handle welcome screen persistence
class WelcomeService {
  static const _welcomeKey = 'isSeenWelcome';

  // Check if the welcome screen has been seen
  static Future<bool> hasSeenWelcome() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_welcomeKey) ?? false;
    } catch (e) {
      debugPrint('Error loading welcome status: $e');
      return false;
    }
  }

  // Mark the welcome screen as seen
  static Future<void> markWelcomeAsSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_welcomeKey, true);
    } catch (e) {
      debugPrint('Error persisting welcome status: $e');
    }
  }

  // Reset the welcome status (for testing or account reset)
  static Future<void> resetWelcomeStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_welcomeKey, false);
    } catch (e) {
      debugPrint('Error resetting welcome status: $e');
    }
  }
}

class WelcomeNotifier extends Notifier<bool> {
  @override
  bool build() {
    // Default to false (not seen) until initialized
    return false;
  }

  // Initialize the provider with the persisted value
  Future<void> initialize() async {
    state = await WelcomeService.hasSeenWelcome();
  }

  // Mark welcome as seen
  Future<void> markWelcomeAsSeen() async {
    await WelcomeService.markWelcomeAsSeen();
    state = true;
  }

  // Reset welcome status (useful for testing or account reset)
  Future<void> resetWelcomeStatus() async {
    await WelcomeService.resetWelcomeStatus();
    state = false;
  }
}
