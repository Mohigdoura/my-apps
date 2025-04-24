import 'package:auth_test/models/cart_model.dart';
import 'package:auth_test/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodPage extends ConsumerStatefulWidget {
  final MenuItem menuItem;
  const FoodPage({super.key, required this.menuItem});

  @override
  ConsumerState<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends ConsumerState<FoodPage>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool showNutrition = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final double total = widget.menuItem.price * quantity;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero image with gradient overlay
              Stack(
                children: [
                  Hero(
                    tag: 'food-item-${widget.menuItem.id}',
                    child: Image.network(
                      widget.menuItem.imageUrl,
                      height: size.width,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: size.width * 0.7,
                            color: Colors.grey[200],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.no_food,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Image not available",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.menuItem.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '\$${widget.menuItem.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Item details
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.menuItem.desc,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                    ),
                    // Quantity selector
                    SizedBox(height: 30),
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _quantityButton(
                            icon: Icons.remove,
                            onPressed:
                                quantity > 1
                                    ? () {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                    : null,
                          ),
                          SizedBox(width: 20),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          _quantityButton(
                            icon: Icons.add,
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              _animationController.reverse().then((_) {
                cartNotifier.addToCart(widget.menuItem, quantity);
                Navigator.pop(context);

                // Show a nice confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: theme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            '${quantity}x ${widget.menuItem.name} added to cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "Add to Cart · \$${total.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _quantityButton({required IconData icon, VoidCallback? onPressed}) {
    Color iconColor =
        onPressed != null ? Theme.of(context).primaryColor : Colors.grey;

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
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}
