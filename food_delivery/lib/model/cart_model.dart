class CartModel {
  String name;
  String iconPath;
  int number;
  String price;

  CartModel({
    required this.name,
    required this.iconPath,
    required this.number,
    required this.price,
  });

  static List<CartModel> getOrders() {
    List<CartModel> orders = [];

    orders.add(CartModel(
      name: 'Honey Pancake',
      iconPath: 'assets/icons/honey-pancakes.svg',
      number: 1,
      price: '18DT',
    ));

    orders.add(CartModel(
      name: 'Canai Bread',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '3.5DT',
    ));

    orders.add(CartModel(
      name: 'Canai bread',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '15DT',
    ));

    orders.add(CartModel(
      name: 'Canai Brad',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '13DT',
    ));

    orders.add(CartModel(
      name: 'Cnai Bread',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '12DT',
    ));

    orders.add(CartModel(
      name: 'Cani Bread',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '10DT',
    ));

    return orders;
  }
}
