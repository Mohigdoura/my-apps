import 'dart:ui';

import 'package:auth_test/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for the initial loading state
final localeInitializerProvider = FutureProvider<Locale>((ref) async {
  return await LanguageService.loadInitialLocale();
});

// The main language provider
final languageProvider = NotifierProvider<LanguageNotifier, Locale>(() {
  return LanguageNotifier();
});

// A service class to handle locale operations
class LanguageService {
  static const _localeKey = 'selected_locale';

  // Load the initial locale from preferences or device
  static Future<Locale> loadInitialLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeString = prefs.getString(_localeKey);

      if (localeString != null) {
        final parts = localeString.split('_');
        if (parts.length == 2) {
          final locale = Locale(parts[0], parts[1]);
          if (L10n.all.contains(locale)) {
            return locale;
          }
        } else if (parts.isNotEmpty) {
          final locale = Locale(parts[0]);
          if (L10n.all.contains(locale)) {
            return locale;
          }
        }
      }

      // Fall back to device locale or English
      return getDeviceLocale();
    } catch (e) {
      debugPrint('Error loading persisted locale: $e');
      return getDeviceLocale();
    }
  }

  // Get the device locale or fall back to English
  static Locale getDeviceLocale() {
    try {
      final deviceLocale = PlatformDispatcher.instance.locale;
      if (L10n.all.contains(deviceLocale)) {
        return deviceLocale;
      }

      final languageOnly = Locale(deviceLocale.languageCode);
      if (L10n.all.contains(languageOnly)) {
        return languageOnly;
      }
    } catch (e) {
      debugPrint('Error getting device locale: $e');
    }
    return const Locale('en');
  }

  // Save locale to shared preferences
  static Future<void> persistLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeString =
          locale.countryCode != null
              ? '${locale.languageCode}_${locale.countryCode}'
              : locale.languageCode;

      await prefs.setString(_localeKey, localeString);
    } catch (e) {
      debugPrint('Error persisting locale: $e');
    }
  }

  // Clear saved locale from preferences
  static Future<void> clearPersistedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localeKey);
    } catch (e) {
      debugPrint('Error clearing persisted locale: $e');
    }
  }
}

class LanguageNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    // Start with English as a default that will be overridden when initialized
    return const Locale('en');
  }

  // This method should be called after the app initializes
  Future<void> initialize() async {
    state = await LanguageService.loadInitialLocale();
  }

  // Set a new locale
  Future<void> setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return;

    await LanguageService.persistLocale(locale);
    state = locale;
  }

  // Reset to device locale
  Future<void> clearLocale() async {
    await LanguageService.clearPersistedLocale();
    state = LanguageService.getDeviceLocale();
  }

  // Get current locale (always non-null)
  Locale getCurrentLocale() {
    return state;
  }
}
