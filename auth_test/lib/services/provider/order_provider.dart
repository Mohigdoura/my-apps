import 'package:auth_test/services/provider/menu_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auth_test/models/order_model.dart';
import 'package:auth_test/models/order_item_model.dart';

// ─── OrdersNotifier ────────────────────────────────────────────────────────────

class OrdersNotifier extends StateNotifier<AsyncValue<List<OrderModel>>> {
  final SupabaseClient _supabaseClient;
  RealtimeChannel? _orderSubscription;

  OrdersNotifier(this._supabaseClient) : super(const AsyncValue.loading()) {
    print('[OrdersNotifier] init');
    fetchOrders();
    _setupOrderStream();
  }

  void _setupOrderStream() {
    print('[OrdersNotifier] setting up realtime stream');
    _orderSubscription =
        _supabaseClient
            .channel('public:orders')
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'orders',
              callback: (payload) {
                print('[OrdersNotifier] realtime payload: $payload');
                fetchOrders();
              },
            )
            .subscribe();
  }

  @override
  void dispose() {
    print('[OrdersNotifier] dispose, unsubscribing');
    _orderSubscription?.unsubscribe();
    super.dispose();
  }

  Future<void> fetchOrders() async {
    print('[fetchOrders] start');
    try {
      state = const AsyncValue.loading();
      print('[fetchOrders] loading state set');

      final response = await _supabaseClient
          .from('orders')
          .select()
          .order('created_at', ascending: true);
      print('[fetchOrders] raw response (${response.runtimeType}): $response');

      final List<OrderModel> orders =
          (response as List<dynamic>).map<OrderModel>((item) {
            print('  [fetchOrders] parsing item: $item');
            try {
              return OrderModel.fromJson(item as Map<String, dynamic>);
            } catch (e, stack) {
              debugPrint('[fetchOrders] parse ERROR: $e\n$stack');
              return OrderModel(
                id: DateTime.now().millisecondsSinceEpoch,
                clientId: 'error',
              );
            }
          }).toList();

      print('[fetchOrders] parsed ${orders.length} orders');
      state = AsyncValue.data(orders);
      print('[fetchOrders] data state set');
    } catch (error, stackTrace) {
      print('[fetchOrders] CATCH error: $error');
      debugPrint('[fetchOrders] stack: $stackTrace');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<int> createOrder(OrderModel order) async {
    print('[createOrder] start: clientId=${order.clientId}');
    try {
      final response =
          await _supabaseClient
              .from('orders')
              .insert({
                'clientId': order.clientId,
                'clientName': order.clientName,
                'instructions': order.instructions,
              })
              .select()
              .single();
      print('[createOrder] response: $response');
      final newId = response['id'] as int;
      print('[createOrder] new id = $newId');
      return newId;
    } catch (error, stack) {
      print('[createOrder] ERROR: $error');
      debugPrint('[createOrder] stack: $stack');
      throw Exception('Failed to create order: $error');
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    print('[updateOrder] start: id=${order.id}');
    try {
      final res = await _supabaseClient
          .from('orders')
          .update({'status': order.status})
          .eq('id', order.id!);
      print('[updateOrder] response: $res');
    } catch (error, stack) {
      print('[updateOrder] ERROR: $error');
      debugPrint('[updateOrder] stack: $stack');
      throw Exception('Failed to update order: $error');
    }
  }

  Future<void> deleteOrder(int orderId) async {
    print('[deleteOrder] start: id=$orderId');
    try {
      print('[deleteOrder] deleting order_items for orderId=$orderId');
      final di = await _supabaseClient
          .from('order_items')
          .delete()
          .eq('orderId', orderId);
      print('[deleteOrder] delete items response: $di');

      print('[deleteOrder] deleting order record');
      final doRes = await _supabaseClient
          .from('orders')
          .delete()
          .eq('id', orderId);
      print('[deleteOrder] delete order response: $doRes');
    } catch (error, stack) {
      print('[deleteOrder] ERROR: $error');
      debugPrint('[deleteOrder] stack: $stack');
      throw Exception('Failed to delete order: $error');
    }
  }
}

// ─── OrderItemsNotifier ────────────────────────────────────────────────────────

class OrderItemsNotifier
    extends StateNotifier<AsyncValue<List<OrderItemModel>>> {
  final SupabaseClient _supabaseClient;
  final int _orderId;
  RealtimeChannel? _orderItemsSubscription;

  OrderItemsNotifier(this._supabaseClient, this._orderId)
    : super(const AsyncValue.loading()) {
    print('[OrderItemsNotifier] init for orderId=$_orderId');
    fetchOrderItems();
    _setupOrderItemsStream();
  }

  void _setupOrderItemsStream() {
    print('[OrderItemsNotifier] setting up realtime stream');
    _orderItemsSubscription =
        _supabaseClient
            .channel('public:order_items')
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'order_items',
              callback: (payload) {
                print('[OrderItemsNotifier] realtime payload: $payload');
                fetchOrderItems();
              },
            )
            .subscribe();
  }

  @override
  void dispose() {
    print('[OrderItemsNotifier] dispose, unsubscribing');
    _orderItemsSubscription?.unsubscribe();
    super.dispose();
  }

  Future<void> fetchOrderItems() async {
    print('[fetchOrderItems] start for orderId=$_orderId');
    try {
      state = const AsyncValue.loading();
      print('[fetchOrderItems] loading state set');

      final response = await _supabaseClient
          .from('order_items')
          .select()
          .eq('orderId', _orderId)
          .order('created_at', ascending: false);
      print('[fetchOrderItems] raw response: $response orderID $_orderId');

      final List<OrderItemModel> orderItems =
          (response as List<dynamic>).map<OrderItemModel>((item) {
            print('  [fetchOrderItems] parsing item: $item');
            try {
              return OrderItemModel.fromJson(item as Map<String, dynamic>);
            } catch (e, stack) {
              debugPrint('[fetchOrderItems] parse ERROR: $e\n$stack');
              return OrderItemModel(
                id: DateTime.now().millisecondsSinceEpoch,
                orderId: _orderId,
                menuItemId: -1,
                count: 0,
              );
            }
          }).toList();

      print('[fetchOrderItems] parsed ${orderItems.length} items');
      state = AsyncValue.data(orderItems);
      print('[fetchOrderItems] data state set');
    } catch (error, stack) {
      print('[fetchOrderItems] CATCH error: $error');
      debugPrint('[fetchOrderItems] stack: $stack');
      state = AsyncValue.error(error, stack);
    }
  }

  Future<String> addOrderItem(OrderItemModel orderItem) async {
    print('[addOrderItem] start: $orderItem');
    try {
      final response =
          await _supabaseClient
              .from('order_items')
              .insert({
                'orderId': orderItem.orderId,
                'menuItemId': orderItem.menuItemId,
                'count': orderItem.count,
              })
              .select()
              .single();
      print('[addOrderItem] response: $response');
      return response['id'].toString();
    } catch (error, stack) {
      print('[addOrderItem] ERROR: $error');
      debugPrint('[addOrderItem] stack: $stack');
      throw Exception('Failed to add order item: $error');
    }
  }

  Future<void> updateOrderItem(OrderItemModel orderItem) async {
    print('[updateOrderItem] start: $orderItem');
    try {
      final res = await _supabaseClient
          .from('order_items')
          .update({
            'orderId': orderItem.orderId,
            'menuItemId': orderItem.menuItemId,
            'count': orderItem.count,
          })
          .eq('id', orderItem.id!);
      print('[updateOrderItem] response: $res');
    } catch (error, stack) {
      print('[updateOrderItem] ERROR: $error');
      debugPrint('[updateOrderItem] stack: $stack');
      throw Exception('Failed to update order item: $error');
    }
  }

  Future<void> deleteOrderItem(String orderItemId) async {
    print('[deleteOrderItem] start: id=$orderItemId');
    try {
      final res = await _supabaseClient
          .from('order_items')
          .delete()
          .eq('id', orderItemId);
      print('[deleteOrderItem] response: $res');
    } catch (error, stack) {
      print('[deleteOrderItem] ERROR: $error');
      debugPrint('[deleteOrderItem] stack: $stack');
      throw Exception('Failed to delete order item: $error');
    }
  }

  Future<void> updateItemCount(String orderItemId, int newCount) async {
    print('[updateItemCount] start: id=$orderItemId, newCount=$newCount');
    try {
      if (newCount <= 0) {
        print('[updateItemCount] count <= 0, deleting item');
        await deleteOrderItem(orderItemId);
      } else {
        final res = await _supabaseClient
            .from('order_items')
            .update({'count': newCount})
            .eq('id', orderItemId);
        print('[updateItemCount] response: $res');
      }
    } catch (error, stack) {
      print('[updateItemCount] ERROR: $error');
      debugPrint('[updateItemCount] stack: $stack');
      throw Exception('Failed to update item count: $error');
    }
  }
}

// ─── Provider declarations ─────────────────────────────────────────────────────

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, AsyncValue<List<OrderModel>>>((ref) {
      final supabaseClient = ref.watch(supabaseClientProvider);
      return OrdersNotifier(supabaseClient);
    });

final orderProvider = Provider.family<AsyncValue<OrderModel?>, int>((
  ref,
  orderId,
) {
  print('[orderProvider] watching orderId=$orderId');
  final ordersAsyncValue = ref.watch(ordersProvider);
  return ordersAsyncValue.when(
    data: (orders) {
      final order = orders.firstWhere(
        (o) => o.id == orderId,
        orElse: () {
          print('[orderProvider] no match for id=$orderId');
          return OrderModel(id: -1, clientId: '');
        },
      );
      print('[orderProvider] found order: $order');
      return AsyncValue.data(order);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, st) {
      print('[orderProvider] ERROR: $error');
      return AsyncValue.error(error, st);
    },
  );
});

final orderTotalPriceProvider = Provider.family<AsyncValue<double>, int>((
  ref,
  orderId,
) {
  final orderItemsAsync = ref.watch(orderItemsProvider(orderId));
  final menuItemsAsync = ref.watch(menuItemsProvider);

  return orderItemsAsync.when(
    data: (items) {
      return menuItemsAsync.when(
        data: (menuItems) {
          double total = 0;
          for (var item in items) {
            final menuItem = menuItems.firstWhere(
              (element) => element.id == item.menuItemId,
            );

            total += item.count * menuItem.price;
          }
          return AsyncValue.data(total);
        },
        loading: () => const AsyncValue.loading(),
        error: (error, stack) => AsyncValue.error(error, stack),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

final orderItemsProvider = StateNotifierProvider.family<
  OrderItemsNotifier,
  AsyncValue<List<OrderItemModel>>,
  int
>((ref, orderId) {
  print('[orderItemsProvider] watching orderId=$orderId');
  final supabaseClient = ref.watch(supabaseClientProvider);
  return OrderItemsNotifier(supabaseClient, orderId);
});

final orderTotalItemsProvider = Provider.family<AsyncValue<int>, int>((
  ref,
  orderId,
) {
  print('[orderTotalItemsProvider] computing total for orderId=$orderId');
  final itemsAsync = ref.watch(orderItemsProvider(orderId));
  return itemsAsync.when(
    data: (items) {
      final total = items.fold(0, (sum, i) => sum + i.count);
      print('[orderTotalItemsProvider] total=$total');
      return AsyncValue.data(total);
    },
    loading: () {
      print('[orderTotalItemsProvider] loading');
      return const AsyncValue.loading();
    },
    error: (error, st) {
      print('[orderTotalItemsProvider] ERROR: $error');
      return AsyncValue.error(error, st);
    },
  );
});

final clientOrdersProvider =
    Provider.family<AsyncValue<List<OrderModel>>, String>((ref, clientId) {
      print('[clientOrdersProvider] filtering clientId=$clientId');
      final ordersAsyncValue = ref.watch(ordersProvider);
      return ordersAsyncValue.when(
        data: (orders) {
          final filtered = orders.where((o) => o.clientId == clientId).toList();
          print('[clientOrdersProvider] found ${filtered.length} orders');
          return AsyncValue.data(filtered);
        },
        loading: () => const AsyncValue.loading(),
        error: (error, st) {
          print('[clientOrdersProvider] ERROR: $error');
          return AsyncValue.error(error, st);
        },
      );
    });

// Provider to calculate total earnings for the restaurant from all completed orders
final restaurantTotalEarningsProvider = FutureProvider<double>((ref) async {
  final ordersAsyncValue = ref.watch(ordersProvider);

  // If still loading or error, return 0
  final orders = ordersAsyncValue.value;
  if (orders == null) {
    return 0.0;
  }

  final completedOrders =
      orders.where((order) => order.status == 'done').toList();

  if (completedOrders.isEmpty) {
    return 0.0;
  }

  double totalEarnings = 0.0;

  for (final order in completedOrders) {
    final orderTotalPriceAsync = ref.watch(orderTotalPriceProvider(order.id!));

    if (orderTotalPriceAsync.hasValue) {
      totalEarnings += orderTotalPriceAsync.value ?? 0.0;
    }
  }

  return totalEarnings;
});
