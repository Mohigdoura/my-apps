import 'package:auth_test/models/menu_item.dart';
import 'package:auth_test/services/auth/auth_service.dart';
import 'package:auth_test/services/provider/menu_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = AuthService();
    final menuItemsNotifier = ref.read(menuItemsProvider.notifier);
    void logout() async {
      await authService.signOut();
    }

    Widget foodTile(List<MenuItem> menuItems, int index) {
      return Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 10, right: 25),
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
                menuItems[index].isavailable
                    ? Colors.blue.shade300
                    : Colors.grey.shade400,
          ),
          child: ListTile(
            leading: Icon(Icons.fastfood, size: 40),
            onTap: () {},
            title: Text(
              menuItems[index].name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menuItems[index].desc),
                SizedBox(height: 4),
                Text(
                  "Type: ${menuItems[index].type}",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                if (!menuItems[index].isavailable)
                  Text(
                    "Currently unavailable",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${menuItems[index].price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
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
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: menuItems.length,
                          itemBuilder:
                              (context, index) => foodTile(menuItems, index),
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
