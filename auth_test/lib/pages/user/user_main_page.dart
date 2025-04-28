import 'package:auth_test/models/cart_model.dart';
import 'package:auth_test/pages/user/cart_page.dart';
import 'package:auth_test/pages/user/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for managing the selected tab index
final selectedTabProvider = StateProvider<int>((ref) => 0);

class UserMainPage extends ConsumerWidget {
  const UserMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: const [HomePage(), CartPage()],
      ),
      bottomNavigationBar: _buildBottomNavBar(theme, selectedTab, ref),
    );
  }

  BottomNavigationBar _buildBottomNavBar(
    ThemeData theme,
    int selectedTab,
    WidgetRef ref,
  ) {
    final cart = ref.watch(cartProvider);

    return BottomNavigationBar(
      currentIndex: selectedTab,
      onTap: (index) => ref.read(selectedTabProvider.notifier).state = index,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      showUnselectedLabels: false,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      items: [
        _buildNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
          isActive: selectedTab == 0,
          theme: theme,
        ),
        _buildNavItem(
          icon: Icons.shopping_cart_outlined,
          activeIcon: Icons.shopping_cart,
          label: 'Cart',
          isActive: selectedTab == 1,
          theme: theme,
          badgeCount: cart.getTotalItems(),
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required ThemeData theme,
    int? badgeCount,
  }) {
    Widget iconWidget = Padding(
      padding: const EdgeInsets.all(6.0),
      child: Icon(isActive ? activeIcon : icon, size: 28),
    );

    // Add badge if necessary
    if (badgeCount != null && badgeCount > 0) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Center(
                child: Text(
                  badgeCount.toString(),
                  style: TextStyle(
                    color: theme.colorScheme.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return BottomNavigationBarItem(
      icon: iconWidget,
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(activeIcon, size: 28, color: theme.colorScheme.primary),
            if (badgeCount != null && badgeCount > 0)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount.toString(),
                      style: TextStyle(
                        color: theme.colorScheme.onError,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      label: label,
    );
  }
}
