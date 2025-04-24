import 'package:auth_test/models/cart_model.dart';
import 'package:auth_test/models/menu_item.dart';
import 'package:auth_test/pages/user/pay_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  // Remove item from the cart
  void removeFromCart(
    BuildContext context,
    MenuItem menuItem,
    CartNotifier cartNotifier,
  ) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Remove Item',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you sure you want to remove:'),
                SizedBox(height: 12),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        menuItem.imageUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 50,
                              width: 50,
                              color: Colors.grey[200],
                              child: Icon(Icons.no_food, color: Colors.grey),
                            ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        menuItem.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Remove'),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                  cartNotifier.removeFromCart(menuItem);

                  // Show visual feedback with a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.remove_shopping_cart, color: Colors.white),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text('${menuItem.name} removed from cart'),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.red.shade700,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
    );
  }

  void decrementItemCount(
    BuildContext context,
    MenuItem menuItem,
    CartNotifier cartNotifier,
    CartModel cart,
  ) {
    HapticFeedback.lightImpact();
    if (cart.cart[menuItem] != 1) {
      cartNotifier.decrementItemCount(menuItem);
    } else {
      removeFromCart(context, menuItem, cartNotifier);
    }
  }

  void incrementItemCount(
    BuildContext context,
    MenuItem menuItem,
    CartNotifier cartNotifier,
  ) {
    HapticFeedback.lightImpact();
    cartNotifier.addToCart(menuItem, 1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider); // data
    final cartNotifier = ref.read(cartProvider.notifier); // notifier
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(
          "Your Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 0,
        actions: [
          if (cart.cart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.white),
                tooltip: 'Clear Cart',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            'Clear Cart',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'Are you sure you want to remove all items?',
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Clear All'),
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                Navigator.pop(context);
                                cartNotifier.clearCart();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 12),
                                        Text('Cart cleared'),
                                      ],
                                    ),
                                    backgroundColor: Colors.red.shade700,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                  );
                },
              ),
            ),
        ],
      ),
      body:
          cart.cart.isEmpty
              ? _buildEmptyCart(theme, context)
              : _buildCartContent(context, cart, cartNotifier, theme),
    );
  }

  Widget _buildEmptyCart(ThemeData theme, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: theme.primaryColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Add some delicious items to get started",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.restaurant_menu),
            label: Text("Browse Menu"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    CartModel cart,
    CartNotifier cartNotifier,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: cart.cart.length,
            itemBuilder: (context, index) {
              final menuItem = cart.cart.keys.elementAt(index);
              final itemCount = cart.cart[menuItem]!;
              final itemTotal = menuItem.price * itemCount;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildCartItem(
                  context,
                  menuItem,
                  itemCount,
                  itemTotal,
                  cart,
                  cartNotifier,
                  theme,
                ),
              );
            },
          ),
        ),
        // Cart summary and payment
        if (cart.cart.isNotEmpty) _buildCartSummary(context, cart, theme),
      ],
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    MenuItem menuItem,
    int itemCount,
    double itemTotal,
    CartModel cart,
    CartNotifier cartNotifier,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onLongPress: () => removeFromCart(context, menuItem, cartNotifier),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Item image
                  Hero(
                    tag: 'food-item-${menuItem.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        menuItem.imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.no_food,
                                color: Colors.grey,
                                size: 32,
                              ),
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  // Item details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menuItem.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$${menuItem.price.toStringAsFixed(2)} each',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Total: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$${itemTotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Quantity controls
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _quantityButton(
                          icon: itemCount > 1 ? Icons.remove : Icons.delete,
                          color:
                              itemCount > 1 ? theme.primaryColor : Colors.red,
                          onPressed:
                              () => decrementItemCount(
                                context,
                                menuItem,
                                cartNotifier,
                                cart,
                              ),
                        ),
                        Container(
                          width: 32,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            transitionBuilder: (
                              Widget child,
                              Animation<double> animation,
                            ) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Text(
                              '$itemCount',
                              key: ValueKey<int>(itemCount),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        _quantityButton(
                          icon: Icons.add,
                          color: theme.primaryColor,
                          onPressed:
                              () => incrementItemCount(
                                context,
                                menuItem,
                                cartNotifier,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildCartSummary(
    BuildContext context,
    CartModel cart,
    ThemeData theme,
  ) {
    final totalPrice = cart.getTotalPrice();
    final itemCount = cart.getTotalItems();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary information
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${itemCount} ${itemCount == 1 ? 'item' : 'items'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) => PayPage(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 0),
              ),
              child: Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
