import 'package:advanced_shop/components/my_drawer.dart';
import 'package:advanced_shop/components/my_product_tile.dart';
import 'package:advanced_shop/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    //access profucts in shop
    final products = context.watch<Shop>().shop;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Shop Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart_page');
            },
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                //show number of items in cart
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.red,
                    child: Center(
                      child: Text(
                        context.watch<Shop>().counter.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          const SizedBox(height: 25),

          //shop subtitle
          Center(
            child: Text(
              'Pick fron a selected list of premium products',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          //product list
          SizedBox(
            height: 550,
            child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(15),
              itemBuilder: (context, index) {
                //get each individual product from shop
                final product = products[index];

                //return as a product tile
                return MyProductTile(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}
