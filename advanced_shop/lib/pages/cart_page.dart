import 'package:advanced_shop/components/my_button.dart';
import 'package:advanced_shop/models/product.dart';
import 'package:advanced_shop/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  //remove item from the cart
  void removeItemFromCart(BuildContext context, Product product) {
    if (context.read<Shop>().cart[product] != 1) {
      context.read<Shop>().removeFromCart(product);
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: Text('remove this to your cart?'),
              actions: [
                MaterialButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                MaterialButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.pop(context);
                    //add to cart
                    context.read<Shop>().removeFromCart(product);
                  },
                ),
              ],
            ),
      );
    }
  }

  void addCount(BuildContext context, Product product) {
    context.read<Shop>().addToCart(product);
  }

  // user pressed pay button
  void payButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) =>
              AlertDialog(content: Text('User wants to pay !!'), actions: []),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Shop>().cart;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Cart Page"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child:
                cart.isEmpty
                    ? Center(child: Text("Your cart is empty"))
                    : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        // get individual item in the cart
                        final item = cart.keys.elementAt(index);

                        //return as list tile
                        return ListTile(
                          leading: AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(item.name),
                          subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add_circle),
                                onPressed: () => addCount(context, item),
                              ),
                              Text(
                                cart[item].toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed:
                                    () => removeItemFromCart(context, item),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
          // pay button
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: MyButton(
              onTap: () => payButtonPressed(context),
              child: Text("PAY NOW"),
            ),
          ),
        ],
      ),
    );
  }
}
