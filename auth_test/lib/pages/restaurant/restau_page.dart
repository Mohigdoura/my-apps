import 'package:auth_test/models/menu_item.dart';
import 'package:auth_test/pages/restaurant/add_item_page.dart';
import 'package:auth_test/services/auth/auth_service.dart';
import 'package:auth_test/services/provider/menu_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestauPage extends ConsumerWidget {
  const RestauPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = AuthService();
    final menuItemsNotifier = ref.read(menuItemsProvider.notifier);
    void logout() async {
      await authService.signOut();
    }

    Widget foodTile(MenuItem menuItem, int index) {
      return Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 10, right: 25),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMenuItemPage(menuItem: menuItem),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  menuItem.isavailable
                      ? Colors.blue.shade300
                      : Colors.grey.shade400,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Image.network(
                      menuItem.imageUrl,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          menuItem.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(menuItem.desc),
                        SizedBox(height: 4),
                        Text(
                          "Type: ${menuItem.type}",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        if (!menuItem.isavailable)
                          Text(
                            "Currently unavailable",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${menuItem.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.blue,
                          borderRadius: BorderRadius.circular(18),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              8.0,
                            ), // bigger tap area
                            child: Icon(Icons.delete),
                          ),
                          onTap: () {
                            final itemId = menuItem.id;
                            if (itemId!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Error: Invalid menu item ID"),
                                ),
                              );
                              return;
                            }

                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text("Delete Item"),
                                    content: Text(
                                      "Are you sure you want to delete ${menuItem.name}?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          menuItemsNotifier.deleteMenuItem(
                                            menuItem,
                                          );
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Menu"),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMenuItemPage()),
            ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final menuItemsAsyncValue = ref.watch(menuItemsProvider);

          return menuItemsAsyncValue.when(
            data:
                (menuItems) =>
                    menuItems.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No menu items yet!",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddMenuItemPage(),
                                      ),
                                    ),
                                child: Text("Add Your First Item"),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: menuItems.length,
                          itemBuilder: (context, index) {
                            if (menuItems[index].id!.isEmpty) {
                              return const ListTile(
                                title: Text("Invalid menu item"),
                                leading: Icon(Icons.error),
                              );
                            }
                            final menuItem = menuItems[index];
                            return foodTile(menuItem, index);
                          },
                        ),
            loading: () => Center(child: CircularProgressIndicator()),
            error:
                (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Error loading menu items',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => menuItemsNotifier.fetchMenuItems(),
                        child: Text("Try Again"),
                      ),
                    ],
                  ),
                ),
          );
        },
      ),
    );
  }
}
