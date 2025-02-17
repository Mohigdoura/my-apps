class PopularfoodModel {
  String name;
  String iconPath;
  String price;
  bool boxIsSelected;

  // ignore: prefer_typing_uninitialized_variables
  var viewIsSelected;

  PopularfoodModel(
      {required this.name,
      required this.iconPath,
      required this.price,
      required this.boxIsSelected});

  static List<PopularfoodModel> getPopularDiets() {
    List<PopularfoodModel> popularDiets = [];

    popularDiets.add(PopularfoodModel(
      name: 'sandwitch',
      iconPath: 'assets/icons/blueberry-pancake.svg',
      price: '7DT',
      boxIsSelected: true,
    ));

    popularDiets.add(PopularfoodModel(
      name: 'pizza',
      iconPath: 'assets/icons/salmon-nigiri.svg',
      price: '20DT',
      boxIsSelected: false,
    ));

    return popularDiets;
  }
}
