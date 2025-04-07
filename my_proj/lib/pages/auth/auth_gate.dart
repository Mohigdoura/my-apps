import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_proj/pages/auth/auth_page.dart';
import 'package:my_proj/pages/auth/home_gate.dart';
import 'package:my_proj/pages/delivery/delivery_home_gate.dart';
import 'package:my_proj/pages/error_screen.dart';
import 'package:my_proj/pages/loading_screen.dart';
import 'package:my_proj/pages/restaurant/restaurant_home_gate.dart';
import 'package:my_proj/providers/user_provider.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userRoleAsync = ref.watch(userRoleProvider);

    return authState.when(
      loading: () => const LoadingScreen(),
      error: (error, _) => ErrorScreen(error: error.toString()),
      data: (data) {
        if (data.session == null) return LoginPage();

        return userRoleAsync.when(
          loading: () => const LoadingScreen(),
          error: (error, _) => ErrorScreen(error: error.toString()),
          data: (role) {
            switch (role) {
              case 'delivery':
                return const DeliveryHomeGate();
              case 'restaurant':
                return const RestaurantHomeGate();
              default:
                return const HomeGate();
            }
          },
        );
      },
    );
  }
}
