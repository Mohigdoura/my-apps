import 'package:auth_test/models/menu_item.dart';
import 'package:auth_test/pages/restaurant/add_item_page.dart';
import 'package:auth_test/services/provider/menu_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Localization import

class RestaurantFoodItem extends ConsumerWidget {
  final MenuItem menuItem;
  const RestaurantFoodItem({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItemsNotifier = ref.read(menuItemsProvider.notifier);
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!; // Access translations

    void navigateToEditItem() {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  AddMenuItemPage(menuItem: menuItem),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    }

    void confirmDelete() {
      final itemId = menuItem.id;
      if (itemId == null || itemId == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localization.errorInvalidId),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(localization.deleteItem),
              content: Text(localization.confirmDelete(menuItem.name)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localization.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    menuItemsNotifier.deleteMenuItem(menuItem);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localization.itemDeleted(menuItem.name)),
                        backgroundColor: Colors.red[400],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                  ),
                  child: Text(localization.delete),
                ),
              ],
            ),
      );
    }

    return Directionality(
      textDirection:
          localization.localeName == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: !menuItem.isavailable ? Colors.red.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  menuItem.isavailable
                      ? Colors.transparent
                      : Colors.red.shade200,
              width: menuItem.isavailable ? 0 : 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: navigateToEditItem,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 90,
                          height: 90,
                          color: Colors.grey[200],
                          child:
                              menuItem.imageUrl.isNotEmpty
                                  ? Image.network(
                                    menuItem.imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                theme.colorScheme.primary,
                                              ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _noImageWidget(localization),
                                  )
                                  : _noImageWidget(localization),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Text Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    menuItem.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.grey[800],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!menuItem.isavailable)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      localization.unavailable,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[800],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              menuItem.desc,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    menuItem.type,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$${menuItem.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.edit,
                        label: localization.edit,
                        color: theme.colorScheme.primary,
                        onPressed: navigateToEditItem,
                      ),
                      Container(height: 24, width: 1, color: Colors.grey[300]),
                      _buildActionButton(
                        icon:
                            menuItem.isavailable
                                ? Icons.toggle_on
                                : Icons.toggle_off,
                        label:
                            menuItem.isavailable
                                ? localization.available
                                : localization.unavailable,
                        color:
                            menuItem.isavailable ? Colors.green : Colors.grey,
                        onPressed: () {
                          final updatedItem = MenuItem(
                            id: menuItem.id,
                            name: menuItem.name,
                            desc: menuItem.desc,
                            price: menuItem.price,
                            type: menuItem.type,
                            imageUrl: menuItem.imageUrl,
                            isavailable: !menuItem.isavailable,
                          );
                          menuItemsNotifier.updateMenuItem(updatedItem);
                        },
                      ),
                      Container(height: 24, width: 1, color: Colors.grey[300]),
                      _buildActionButton(
                        icon: Icons.delete,
                        label: localization.delete,
                        color: Colors.red,
                        onPressed: confirmDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noImageWidget(AppLocalizations localization) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.fastfood, size: 40, color: Colors.grey[500]),
        const SizedBox(height: 4),
        Text(
          localization.noImage,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
