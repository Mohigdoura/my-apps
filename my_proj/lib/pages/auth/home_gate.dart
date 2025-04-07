import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_proj/core/utils.dart';
import 'package:my_proj/pages/auth/auth_page.dart';
import 'package:my_proj/pages/customer/customer_home_gate.dart';
import 'package:my_proj/pages/delivery/delivery_home_gate.dart';
import 'package:my_proj/pages/restaurant/restaurant_home_gate.dart';

class HomeGate extends ConsumerStatefulWidget {
  const HomeGate({super.key});

  @override
  ConsumerState<HomeGate> createState() => _HomeGateState();
}

class _HomeGateState extends ConsumerState<HomeGate> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    if (userState.isAuthenticated) {
      switch (userState.role) {
        case 'restaurant':
          return const RestaurantHomeGate();
        case 'delivery':
          return const DeliveryHomeGate();
        default:
          return const CustomerHomeGate();
      }
    } else {
      return LoginPage();
    }
  }
}
