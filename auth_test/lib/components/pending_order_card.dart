import 'package:auth_test/models/order_model.dart';
import 'package:auth_test/pages/restaurant/order_details_page.dart';
import 'package:auth_test/services/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PendingOrderCard extends ConsumerStatefulWidget {
  final OrderModel order;

  const PendingOrderCard({required this.order, super.key});

  @override
  ConsumerState<PendingOrderCard> createState() => _PendingOrderCardState();
}

class _PendingOrderCardState extends ConsumerState<PendingOrderCard> {
  void _navigateToOrderDetails(BuildContext context, int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(orderId: orderId),
      ),
    );
  }

  void _confirmDeleteOrder(BuildContext context, WidgetRef ref, int orderId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.deleteOrder),
            content: Text(l10n.confirmDeleteOrder),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(ordersProvider.notifier).deleteOrder(orderId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.orderDeleted),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(l10n.delete),
              ),
            ],
          ),
    );
  }

  String _getTimeAgo(BuildContext context, DateTime? dateTime) {
    final l10n = AppLocalizations.of(context)!;
    if (dateTime == null) return l10n.unknown;
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return l10n.daysAgo(difference.inDays);
    }
    if (difference.inHours > 0) {
      return l10n.hoursAgo(difference.inHours);
    }
    if (difference.inMinutes > 0) {
      return l10n.minutesAgo(difference.inMinutes);
    }
    return l10n.justNow;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final order = widget.order;
    final orderTotalItemsAsync = ref.watch(orderTotalItemsProvider(order.id!));
    final orderTotalPrice = ref.watch(orderTotalPriceProvider(order.id!));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToOrderDetails(context, order.id!),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${l10n.orderNumber} #${order.id!}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getTimeAgo(context, order.created_at),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Row(
                        children: [
                          Text(
                            "${l10n.customerId}: ${order.clientName}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  orderTotalItemsAsync.when(
                    data:
                        (totalItems) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "$totalItems ${totalItems == 1 ? l10n.item : l10n.items}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.secondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    loading:
                        () => const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    error: (_, __) => Text(l10n.errorLoadingItems),
                  ),
                ],
              ),
              if (order.instructions != null &&
                  order.instructions!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  "${l10n.instructions}:",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.instructions!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: orderTotalPrice.when(
                      data:
                          (total) => Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${"Total"}: \$${total.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      loading:
                          () => const CircularProgressIndicator(strokeWidth: 2),
                      error: (_, __) => Text(l10n.errorLoadingItems),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: Text(l10n.delete),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed:
                        () => _confirmDeleteOrder(context, ref, order.id!),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.visibility, size: 18),
                    label: Text(l10n.view),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: theme.colorScheme.primary,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed:
                        () => _navigateToOrderDetails(context, order.id!),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
