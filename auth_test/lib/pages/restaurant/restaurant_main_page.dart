import 'package:auth_test/pages/restaurant/orders_page.dart';
import 'package:auth_test/pages/restaurant/restau_page.dart';
import 'package:auth_test/pages/restaurant/restau_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a provider to manage the selected tab index
final selectedTabProvider = StateProvider<int>((ref) => 0);

class RestaurantMainPage extends ConsumerWidget {
  const RestaurantMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the selected tab index
    final selectedTab = ref.watch(selectedTabProvider);

    return Scaffold(
      // Use IndexedStack to maintain state across tab switches
      body: IndexedStack(
        index: selectedTab,
        children: const [RestauPage(), OrdersPage(), RestauProfilePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: (index) {
          // Update the selected tab index
          ref.read(selectedTabProvider.notifier).state = index;
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withValues(alpha: 0.3),
              ),
              child: Icon(Icons.home),
            ),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withValues(alpha: 0.3),
              ),
              child: Icon(Icons.shopping_bag),
            ),
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            activeIcon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withValues(alpha: 0.3),
              ),
              child: Icon(Icons.person),
            ),
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
