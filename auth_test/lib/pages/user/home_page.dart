import 'package:auth_test/components/food_item_card.dart';
import 'package:auth_test/models/cart_model.dart';
import 'package:auth_test/pages/user/cart_page.dart';
import 'package:auth_test/services/auth/auth_service.dart';
import 'package:auth_test/services/provider/menu_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = AuthService();
    final menuItemsNotifier = ref.read(menuItemsProvider.notifier);
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    void logout() async {
      // Show confirmation dialog
      bool confirm =
          await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
          ) ??
          false;

      if (confirm) {
        await authService.signOut();
      }
    }

    void navigateToCart() {
      HapticFeedback.mediumImpact();
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => CartPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          onPressed: logout,
          icon: Icon(Icons.logout_rounded, color: Colors.white),
          tooltip: 'Logout',
        ),
        title: Text(
          "Food Menu",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: navigateToCart,
                  icon: Icon(
                    Icons.shopping_cart_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  tooltip: 'View Cart',
                ),
                if (cart.getTotalItems() > 0)
                  Positioned(
                    right: 0,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                      child: Center(
                        child: Text(
                          cart.getTotalItems().toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: () async {
          await menuItemsNotifier.fetchMenuItems();
        },
        child: Consumer(
          builder: (context, ref, child) {
            final menuItemsAsyncValue = ref.watch(menuItemsProvider);

            return menuItemsAsyncValue.when(
              data:
                  (menuItems) =>
                      menuItems.isEmpty
                          ? _buildEmptyState()
                          : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              itemCount: menuItems.length,
                              itemBuilder: (context, index) {
                                if (menuItems[index].id!.isEmpty) {
                                  return _buildErrorItem();
                                }
                                final menuItem = menuItems[index];
                                return FoodItemCard(menuItem: menuItem);
                              },
                            ),
                          ),
              loading:
                  () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Loading menu...",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
              error:
                  (error, stackTrace) => _buildErrorState(
                    error,
                    () => menuItemsNotifier.fetchMenuItems(),
                  ),
            );
          },
        ),
      ),
      bottomNavigationBar:
          cart.cart.isNotEmpty
              ? AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 70,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                child: ElevatedButton.icon(
                  onPressed: navigateToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(Icons.shopping_bag_outlined),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${cart.getTotalItems()} items",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "\$${cart.getTotalPrice().toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 100, color: Colors.grey[400]),
          SizedBox(height: 24),
          Text(
            "No Menu Items Available",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Pull down to refresh",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.refresh),
            label: Text("Refresh"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorItem() {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 32, color: Colors.red),
          SizedBox(height: 8),
          Text(
            "Invalid Item",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, size: 60, color: Colors.red),
            ),
            SizedBox(height: 24),
            Text(
              'Unable to Load Menu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Text(
              error.toString(),
              style: TextStyle(color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text("Try Again"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
