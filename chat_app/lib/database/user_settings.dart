import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  bool isDarkMode;
  String name;
  String email;

  UserSettings({
    required this.isDarkMode,
    required this.name,
    required this.email,
  });

  factory UserSettings.defaultSettings() {
    return UserSettings(isDarkMode: false, name: "User", email: "");
  }
}

class UserSettingsNotifier extends StateNotifier<UserSettings> {
  UserSettingsNotifier() : super(UserSettings.defaultSettings());

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = UserSettings(
      isDarkMode: prefs.getBool("isDarkMode") ?? false,
      name: prefs.getString("name") ?? "User",
      email: prefs.getString("email") ?? "",
    );
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDarkMode", state.isDarkMode);
    await prefs.setString("name", state.name);
    await prefs.setString("email", state.email);
  }

  void updateSettings({bool? isDarkMode, String? name, String? email}) {
    state = UserSettings(
      isDarkMode: isDarkMode ?? state.isDarkMode,
      name: name ?? state.name,
      email: email ?? state.email,
    );
  }
}

// Provider to expose the UserSettingsNotifier
final userSettingsProvider =
    StateNotifierProvider<UserSettingsNotifier, UserSettings>(
      (ref) => UserSettingsNotifier(),
    );
