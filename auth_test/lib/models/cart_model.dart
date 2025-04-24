import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_test/models/menu_item.dart';

final cartProvider = NotifierProvider<CartNotifier, CartModel>(
  () => CartNotifier(),
);

class CartModel {
  final Map<MenuItem, int> cart;
  final int counter;

  CartModel({Map<MenuItem, int>? cart, this.counter = 0})
    : cart = Map.unmodifiable(cart ?? {});

  CartModel copyWith({Map<MenuItem, int>? cart, int? counter}) {
    return CartModel(cart: cart ?? this.cart, counter: counter ?? this.counter);
  }

  double getTotalPrice() {
    return cart.entries.fold(
      0,
      (sum, entry) => sum + entry.key.price * entry.value,
    );
  }

  int getTotalItems() {
    return cart.values.fold(0, (sum, quantity) => sum + quantity);
  }
}

class CartNotifier extends Notifier<CartModel> {
  @override
  CartModel build() => CartModel();

  void addToCart(MenuItem item, int count) {
    final newCart = Map<MenuItem, int>.from(state.cart);
    newCart.update(item, (value) => value + count, ifAbsent: () => count);

    state = CartModel(cart: newCart, counter: state.counter + count);
  }

  void decrementItemCount(MenuItem item) {
    final newCart = Map<MenuItem, int>.from(state.cart);

    if (!newCart.containsKey(item)) return;

    if (newCart[item] == 1) {
      newCart.remove(item);
    } else {
      newCart.update(item, (value) => value - 1);
    }

    final newCounter = state.counter > 0 ? state.counter - 1 : 0;

    state = CartModel(cart: newCart, counter: newCounter);
  }

  void removeFromCart(MenuItem item) {
    final newCart = Map<MenuItem, int>.from(state.cart);

    if (!newCart.containsKey(item)) return;

    newCart.remove(item);

    final newCounter = state.counter > 0 ? state.counter - 1 : 0;

    state = CartModel(cart: newCart, counter: newCounter);
  }

  void clearCart() {
    state = CartModel();
  }
}
