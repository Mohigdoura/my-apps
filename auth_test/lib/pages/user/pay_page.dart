import 'package:auth_test/components/my_text_field.dart';
import 'package:auth_test/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PayPage extends ConsumerStatefulWidget {
  const PayPage({super.key});

  @override
  ConsumerState<PayPage> createState() => _PayPageState();
}

class _PayPageState extends ConsumerState<PayPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController specialInstructionsController =
      TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    phoneController.dispose();
    specialInstructionsController.dispose();
    super.dispose();
  }

  void _processPayment() {
    // Show loading state
    setState(() {
      _isProcessingPayment = true;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });

        // Show success dialog
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Payment Successful!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your order has been placed successfully. You will receive a confirmation shortly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () {
                    // Clear cart and navigate back to menu
                    final cartNotifier = ref.read(cartProvider.notifier);
                    cartNotifier.clearCart();

                    // Navigate back to the menu page (popping all screens until the menu)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Text(
                    "Return to Menu",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartModel cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with total
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '\$${cart.getTotalPrice().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${cart.getTotalItems()} ${cart.getTotalItems() == 1 ? 'item' : 'items'} from This Restaurant",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact information section
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: MyTextField(
                        controller: phoneController,
                        labelText: "Phone number",
                        hintText: "Enter your phone number",
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        icon: const Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Special instructions section
                    const Text(
                      'Special Instructions',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Special instructions field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: MyTextField(
                        controller: specialInstructionsController,
                        labelText: "Special instructions or allergies",
                        hintText: "E.g., No peanuts, gluten-free, etc.",
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        maxLength: 260,
                        icon: const Icon(Icons.note_alt_outlined),
                      ),
                    ),
                    const SizedBox(height: 24), // Order details section
                    const Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildOrderSummaryCard(cart, 1, theme),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed:
                _isProcessingPayment
                    ? null
                    : () {
                      HapticFeedback.mediumImpact();
                      _processPayment();
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade400,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: Size(double.infinity, 0),
            ),
            child:
                _isProcessingPayment
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Processing...",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                    : const Text(
                      "Complete Payment",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(
    CartModel cart,
    int deliveryFee,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.shopping_basket, color: theme.primaryColor),
        ),
        title: const Text(
          "Order Summary",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${cart.getTotalItems()} ${cart.getTotalItems() == 1 ? 'item' : 'items'} • \$${cart.getTotalPrice().toStringAsFixed(2)}",
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          ...cart.cart.entries.map((entry) {
            final menuItem = entry.key;
            final quantity = entry.value;
            final itemTotal = menuItem.price * quantity;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  // Item image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      menuItem.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.no_food,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Item details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menuItem.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$quantity x \$${menuItem.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Item total
                  Text(
                    "\$${itemTotal.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 12),
          const Divider(thickness: 1),
          const SizedBox(height: 12),

          // Totals section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal", style: TextStyle(fontSize: 14)),
              Text(
                "\$${cart.getTotalPrice().toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Delivery", style: TextStyle(fontSize: 14)),
              Text(
                '\$$deliveryFee',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${(cart.getTotalPrice() + deliveryFee).toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
