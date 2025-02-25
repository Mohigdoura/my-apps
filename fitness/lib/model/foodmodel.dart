class FoodModel {
  String name;
  double price;
  String iconPath;
  List<String> resto;

  FoodModel({
    required this.name,
    required this.price,
    required this.iconPath,
    required this.resto,
  });

  static List<FoodModel> getFood() {
    List<FoodModel> foods = [];
    foods.add(FoodModel(
      name: 'Tabouna',
      price: 3.5,
      iconPath: 'assets/icons/plate.svg',
      resto: ['la casa', 'marella'],
    ));
    foods.add(FoodModel(
      name: 'Mlawi',
      price: 4.5,
      iconPath: 'assets/icons/plate.svg',
      resto: ['mdnini'],
    ));
    foods.add(FoodModel(
      name: 'Makloub',
      price: 7.5,
      iconPath: 'assets/icons/plate.svg',
      resto: ['la casa', 'marella'],
    ));
    foods.add(FoodModel(
      name: 'kaskrout',
      price: 5,
      iconPath: 'assets/icons/plate.svg',
      resto: ['abd rhim'],
    ));

    return foods;
  }
}
