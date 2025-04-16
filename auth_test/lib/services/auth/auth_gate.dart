import 'package:auth_test/pages/home_page.dart';
import 'package:auth_test/pages/auth/login_register_page.dart';
import 'package:auth_test/pages/restaurant/restau_page.dart';
import 'package:auth_test/services/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authState.isAuthenticated) {
      return const LoginRegisterPage();
    }

    if (authState.userType == 'restaurant') {
      return RestauPage();
    } else {
      return const HomePage();
    }
  }
}
