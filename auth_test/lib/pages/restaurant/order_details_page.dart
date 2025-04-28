import 'package:auth_test/models/order_item_model.dart';
import 'package:auth_test/models/order_model.dart';
import 'package:auth_test/services/provider/menu_item_provider.dart';
import 'package:auth_test/services/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart'; // Add this for better date formatting

class OrderDetailsPage extends ConsumerWidget {
  final int orderId;

  const OrderDetailsPage({required this.orderId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final orderAsync = ref.watch(orderProvider(orderId));
    final ordersNotifier = ref.read(ordersProvider.notifier);
    final orderItemsAsync = ref.watch(orderItemsProvider(orderId));
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          loc.orderDetails,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: orderAsync.when(
        data: (order) {
          if (order == null || order.id == -1) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    loc.orderNotFound,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            decoration: BoxDecoration(color: Colors.grey[50]),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderHeader(context, order, loc),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc.orderItems,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  const SizedBox(height: 8),
                  Expanded(
                    child: orderItemsAsync.when(
                      data:
                          (items) =>
                              items.isEmpty
                                  ? _buildEmptyState(context, loc)
                                  : _buildOrderItemsList(
                                    context,
                                    ref,
                                    items,
                                    loc,
                                  ),
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error:
                          (error, _) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '${loc.errorLoadingOrderItems}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  error.toString(),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                    ),
                  ),
                  if (order.status == 'pending') ...[
                    _buildStatusButton(
                      context: context,
                      onPressed: () {
                        final newOrder = OrderModel(
                          created_at: order.created_at,
                          instructions: order.instructions,
                          status: 'accepted',
                          clientId: order.clientId,
                          id: order.id,
                        );
                        ordersNotifier.updateOrder(newOrder);
                        Navigator.pop(context);
                      },
                      icon: Icons.check_circle_outline,
                      label: 'Accept Order',
                      color: Colors.green,
                    ),
                  ] else if (order.status == 'accepted') ...[
                    _buildStatusIndicator(context, 'Accepted'),
                    const SizedBox(height: 16),
                    _buildStatusButton(
                      context: context,
                      onPressed: () {
                        final newOrder = OrderModel(
                          created_at: order.created_at,
                          instructions: order.instructions,
                          status: 'done',
                          clientId: order.clientId,
                          id: order.id,
                        );
                        ordersNotifier.updateOrder(newOrder);
                        Navigator.pop(context);
                      },
                      icon: Icons.task_alt,
                      label: 'Mark as Complete',
                      color: theme.colorScheme.primary,
                    ),
                  ] else if (order.status == 'done')
                    _buildStatusIndicator(context, 'Completed'),
                  const SizedBox(height: 16),

                  SizedBox(height: 25),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      '${loc.errorLoadingOrder}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            loc.noItemsInOrder,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(
    BuildContext context,
    OrderModel order,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${loc.orderNumber} #${order.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _formatDate(order.created_at),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              children: [
                Icon(Icons.person, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  '${loc.customerId}:',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.clientName!,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
              ],
            ),
            if (order.instructions != null &&
                order.instructions!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[100]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          color: Colors.amber[800],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${loc.instructions}:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order.instructions!,
                      style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsList(
    BuildContext context,
    WidgetRef ref,
    List<OrderItemModel> items,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final menuItemAsync = ref.watch(menuItemProvider(item.menuItemId));

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.count}x',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: menuItemAsync.when(
                    data:
                        (menuItem) =>
                            menuItem == null
                                ? _buildUnknownItem(loc)
                                : _buildMenuItem(menuItem),
                    loading: () => _buildLoadingItem(loc),
                    error: (_, __) => _buildErrorItem(loc),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(dynamic menuItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          menuItem.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (menuItem.desc.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            menuItem.desc,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildUnknownItem(AppLocalizations loc) {
    return Row(
      children: [
        Icon(Icons.help_outline, color: Colors.grey[500], size: 18),
        const SizedBox(width: 8),
        Text(
          loc.unknownItem,
          style: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingItem(AppLocalizations loc) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          loc.loading,
          style: TextStyle(color: Colors.grey[500], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildErrorItem(AppLocalizations loc) {
    return Row(
      children: [
        Icon(Icons.error_outline, color: Colors.red[300], size: 18),
        const SizedBox(width: 8),
        Text(
          loc.errorLoadingItem,
          style: TextStyle(color: Colors.red[300], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildStatusButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context, String status) {
    final color = status == 'Accepted' ? Colors.green : Colors.blue;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: color[600], size: 24),
          const SizedBox(width: 12),
          Text(
            status,
            style: TextStyle(
              color: color[700],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown date';
    // Using intl package for better formatting
    final formatter = DateFormat('dd MMM, HH:mm');
    return formatter.format(dateTime);
  }
}
