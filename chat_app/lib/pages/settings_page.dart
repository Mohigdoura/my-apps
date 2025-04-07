import 'package:chat_app/database/user_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettingsState = ref.watch(userSettingsProvider);
    final userSettingsNotifier = ref.read(userSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: ListTile(
        tileColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Dark Mode"),
        trailing: CupertinoSwitch(
          value:
              userSettingsState.isDarkMode, // Replace with your dark mode state
          onChanged: (value) {
            userSettingsNotifier.updateSettings(isDarkMode: value);
            userSettingsNotifier.saveSettings(); // Save the updated settings
          },
        ),
      ),
    );
  }
}
