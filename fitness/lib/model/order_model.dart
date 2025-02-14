class OrderModel {
  String name;
  String iconPath;
  int number;
  String price;

  OrderModel({
    required this.name,
    required this.iconPath,
    required this.number,
    required this.price,
  });

  static List<OrderModel> getOrders() {
    List<OrderModel> orders = [];

    orders.add(OrderModel(
      name: 'Honey Pancake',
      iconPath: 'assets/icons/honey-pancakes.svg',
      number: 1,
      price: '30mins',
    ));

    orders.add(OrderModel(
      name: 'Canai Bread',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '20mins',
    ));

    return orders;
  }
}
