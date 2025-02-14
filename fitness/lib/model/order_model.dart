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
      price: '18DT',
    ));

    orders.add(OrderModel(
      name: 'Canai Bread',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '3.5DT',
    ));

    orders.add(OrderModel(
      name: 'Canai bread',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '15DT',
    ));

    orders.add(OrderModel(
      name: 'Canai Brad',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '13DT',
    ));

    orders.add(OrderModel(
      name: 'Cnai Bread',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '12DT',
    ));

    orders.add(OrderModel(
      name: 'Cani Bread',
      iconPath: 'assets/icons/canai-bread.svg',
      number: 1,
      price: '10DT',
    ));

    return orders;
  }
}
