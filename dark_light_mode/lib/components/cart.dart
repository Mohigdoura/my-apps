import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Cart Item Model
class CartItem {
  final String menuItemId;
  final String restaurantId;
  final String name;
  final double price;
  final int quantity;
  final String? specialInstructions;

  CartItem({
    required this.menuItemId,
    required this.restaurantId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.specialInstructions,
  });

  // Create a copy of the cart item with optional modifications
  CartItem copyWith({int? quantity, String? specialInstructions}) {
    return CartItem(
      menuItemId: menuItemId,
      restaurantId: restaurantId,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  // Calculate total price for this item
  double get totalPrice => price * quantity;
}

// Cart State
class CartState {
  final List<CartItem> items;
  final String? selectedRestaurantId;

  CartState({this.items = const [], this.selectedRestaurantId});

  // Calculate total cart value
  double get totalPrice =>
      items.fold(0, (total, item) => total + item.totalPrice);

  // Calculate total items
  int get totalItems => items.fold(0, (total, item) => total + item.quantity);
}

// Cart Notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  // Add item to cart
  void addToCart(CartItem newItem) {
    // If no restaurant selected, set the first restaurant
    final currentState = state;

    // Check if the restaurant is different from previously selected
    if (currentState.selectedRestaurantId != null &&
        currentState.selectedRestaurantId != newItem.restaurantId) {
      throw Exception('Cannot add items from different restaurants');
    }

    // Check if item already exists
    final existingItemIndex = state.items.indexWhere(
      (item) => item.menuItemId == newItem.menuItemId,
    );

    if (existingItemIndex != -1) {
      // Update existing item
      final updatedItems = List<CartItem>.from(state.items);
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + newItem.quantity,
      );

      state = CartState(
        items: updatedItems,
        selectedRestaurantId: newItem.restaurantId,
      );
    } else {
      // Add new item
      state = CartState(
        items: [...state.items, newItem],
        selectedRestaurantId: newItem.restaurantId,
      );
    }
  }

  // Remove item from cart
  void removeFromCart(String menuItemId) {
    state = CartState(
      items:
          state.items.where((item) => item.menuItemId != menuItemId).toList(),
      selectedRestaurantId: state.selectedRestaurantId,
    );
  }

  // Update item quantity
  void updateItemQuantity(String menuItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(menuItemId);
      return;
    }

    final updatedItems =
        state.items.map((item) {
          if (item.menuItemId == menuItemId) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();

    state = CartState(
      items: updatedItems,
      selectedRestaurantId: state.selectedRestaurantId,
    );
  }

  // Clear entire cart
  void clearCart() {
    state = CartState();
  }

  // Add special instructions to an item
  void addSpecialInstructions(String menuItemId, String instructions) {
    final updatedItems =
        state.items.map((item) {
          if (item.menuItemId == menuItemId) {
            return item.copyWith(specialInstructions: instructions);
          }
          return item;
        }).toList();

    state = CartState(
      items: updatedItems,
      selectedRestaurantId: state.selectedRestaurantId,
    );
  }
}

// Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Cart Widget Example
class CartWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartState.items.length,
              itemBuilder: (context, index) {
                final item = cartState.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed:
                            () => cartNotifier.updateItemQuantity(
                              item.menuItemId,
                              item.quantity - 1,
                            ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed:
                            () => cartNotifier.updateItemQuantity(
                              item.menuItemId,
                              item.quantity + 1,
                            ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed:
                            () => cartNotifier.removeFromCart(item.menuItemId),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Cart Summary
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Total Items: ${cartState.totalItems}'),
                Text(
                  'Total Price: \$${cartState.totalPrice.toStringAsFixed(2)}',
                ),
                ElevatedButton(
                  onPressed:
                      cartState.items.isNotEmpty
                          ? () {
                            // Proceed to checkout
                            // You can add navigation or checkout logic here
                          }
                          : null,
                  child: Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Example of Adding to Cart in a Menu Item Widget
class MenuItemWidget extends ConsumerWidget {
  final String menuItemId;
  final String restaurantId;
  final String name;
  final double price;

  MenuItemWidget({
    required this.menuItemId,
    required this.restaurantId,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(name),
      subtitle: Text('\$${price.toStringAsFixed(2)}'),
      trailing: IconButton(
        icon: Icon(Icons.add_shopping_cart),
        onPressed: () {
          try {
            ref
                .read(cartProvider.notifier)
                .addToCart(
                  CartItem(
                    menuItemId: menuItemId,
                    restaurantId: restaurantId,
                    name: name,
                    price: price,
                  ),
                );
            // Show success message
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Item added to cart')));
          } catch (e) {
            // Handle restaurant mismatch
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
    );
  }
}
