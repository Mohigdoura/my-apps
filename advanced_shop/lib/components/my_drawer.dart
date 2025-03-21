import 'package:advanced_shop/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //drawer header
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: Icon(
                    Icons.shopping_bag,
                    size: 72,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              SizedBox(height: 25),

              //shop tile
              MyListTile(
                text: "Shop",
                icon: Icons.home,
                onTap: () => Navigator.pop(context),
              ),

              //cart tile
              MyListTile(
                text: "Cart",
                icon: Icons.shopping_cart,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/cart_page');
                },
              ),
            ],
          ),

          //exit
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListTile(
              text: "Exit",
              icon: Icons.logout,
              onTap:
                  () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/intro_page',
                    (route) => false,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
