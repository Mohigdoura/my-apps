import 'package:auth_test/models/menu_item.dart';
import 'package:auth_test/pages/user/food_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodItemCard extends StatelessWidget {
  final MenuItem menuItem;

  const FoodItemCard({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          menuItem.isavailable
              ? Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          FoodPage(menuItem: menuItem),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              )
              : ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.no_food_outlined, color: Colors.white),
                      SizedBox(width: 12),
                      Text('This item is currently unavailable.'),
                    ],
                  ),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
        },
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with gradient overlay
                  Stack(
                    children: [
                      SizedBox(
                        height: 140,
                        width: double.infinity,
                        child: Image.network(
                          menuItem.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.no_food,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                        ),
                      ),
                      // Gradient
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Price
                      if (menuItem.isavailable)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '\$${menuItem.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      // ❌ Unavailable Banner
                      if (!menuItem.isavailable)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                'Unavailable',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Item info
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menuItem.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:
                                menuItem.isavailable
                                    ? Colors.black
                                    : Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          menuItem.desc,
                          style: TextStyle(
                            color:
                                menuItem.isavailable
                                    ? Colors.grey[600]
                                    : Colors.grey[500],
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
