import 'package:auth_test/pages/welcome/language.dart';
import 'package:auth_test/services/auth/auth_gate.dart';
import 'package:auth_test/services/provider/language_provider.dart';
import 'package:auth_test/services/provider/welcome_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStartup extends ConsumerStatefulWidget {
  const AppStartup({super.key});

  @override
  ConsumerState<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends ConsumerState<AppStartup> {
  @override
  void initState() {
    super.initState();
    // Initialize both providers
    Future.microtask(() {
      ref.read(languageProvider.notifier).initialize();
      ref.read(welcomeProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while initializing
    final welcomeInitializer = ref.watch(welcomeInitializerProvider);

    return welcomeInitializer.when(
      loading: () => const LoadingScreen(),
      error: (error, stack) => ErrorScreen(error: error.toString()),
      data: (_) => const AppRouter(),
    );
  }
}

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the welcome provider to rebuild when its state changes
    final hasSeenWelcome = ref.watch(welcomeProvider);

    // Decide which screen to show based on whether welcome has been seen
    if (!hasSeenWelcome) {
      return Language(
        onComplete: () {
          // Mark welcome as seen when user completes onboarding
          ref.read(welcomeProvider.notifier).markWelcomeAsSeen();
        },
      );
    } else {
      return const AuthGate();
    }
  }
}

// Example loading screen
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

// Example error screen
class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Error: $error')));
  }
}
