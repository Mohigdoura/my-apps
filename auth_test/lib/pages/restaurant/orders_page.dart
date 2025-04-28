import 'package:auth_test/components/accepted_order_card.dart';
import 'package:auth_test/components/completed_order_cart.dart';
import 'package:auth_test/components/pending_order_card.dart';
import 'package:auth_test/models/order_model.dart';
import 'package:auth_test/services/auth/auth_service.dart';
import 'package:auth_test/services/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Changed to 3 tabs
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ordersAsync = ref.watch(ordersProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.ordersTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: theme.colorScheme.primary,
              indicatorWeight: 3,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time),
                      const SizedBox(width: 8),
                      Text("pending"),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline),
                      const SizedBox(width: 8),
                      Text("accepted"),
                    ],
                  ),
                ),
                // New completed tab
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt),
                      const SizedBox(width: 8),
                      Text("completed"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ordersAsync.when(
        data: (orders) {
          final pendingOrders =
              orders.where((order) => order.status == 'pending').toList();
          final acceptedOrders =
              orders.where((order) => order.status == 'accepted').toList();
          // Added completed orders filter
          final completedOrders =
              orders.where((order) => order.status == 'done').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              // Pending Orders Tab
              pendingOrders.isEmpty
                  ? _buildRefreshableEmptyState(
                    context,
                    "noPendingOrders",
                    "noPendingOrdersDescription",
                  )
                  : _buildRefreshableOrdersList(
                    context,
                    ref,
                    pendingOrders,
                    'pending',
                  ),

              // Accepted Orders Tab
              acceptedOrders.isEmpty
                  ? _buildRefreshableEmptyState(
                    context,
                    "noAcceptedOrders",
                    "noAcceptedOrdersDescription",
                  )
                  : _buildRefreshableOrdersList(
                    context,
                    ref,
                    acceptedOrders,
                    'accepted',
                  ),

              // Completed Orders Tab
              completedOrders.isEmpty
                  ? _buildRefreshableEmptyState(
                    context,
                    "noCompletedOrders",
                    "noCompletedOrdersDescription",
                  )
                  : _buildRefreshableOrdersList(
                    context,
                    ref,
                    completedOrders,
                    'completed',
                  ),
            ],
          );
        },
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
                  const SizedBox(height: 16),
                  Text(
                    l10n.loadingOrders,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
        error:
            (error, stack) => _buildErrorState(context, error, () {
              ref.read(ordersProvider.notifier).fetchOrders();
            }),
      ),
    );
  }

  // Wrap empty state with RefreshIndicator
  Widget _buildRefreshableEmptyState(
    BuildContext context,
    String title,
    String description,
  ) {
    return RefreshIndicator(
      onRefresh: () => ref.read(ordersProvider.notifier).fetchOrders(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: _buildEmptyState(context, title, description),
          ),
        ],
      ),
    );
  }

  // Wrap orders list with RefreshIndicator
  Widget _buildRefreshableOrdersList(
    BuildContext context,
    WidgetRef ref,
    List<OrderModel> orders,
    String orderType,
  ) {
    return RefreshIndicator(
      onRefresh: () => ref.read(ordersProvider.notifier).fetchOrders(),
      child: _buildOrdersList(context, ref, orders, orderType),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String description,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    WidgetRef ref,
    List<OrderModel> orders,
    String orderType,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      physics: const AlwaysScrollableScrollPhysics(), // Ensure scrolling works
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        switch (orderType) {
          case 'accepted':
            return AcceptedOrderCard(order: order);
          case 'completed':
            return CompletedOrderCart(order: order);
          default:
            return PendingOrderCard(order: order);
        }
      },
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    Object error,
    VoidCallback onRetry,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, size: 60, color: Colors.red),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.errorLoadingOrders,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error.toString(),
              style: TextStyle(color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.tryAgain),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
