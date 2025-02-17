import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/cart_model.dart';
import '../model/sellers_model.dart';
import '../model/popular_model.dart';
import '../model/restaurants_model.dart';
import '../pages/restopage.dart';

class Foodpage extends StatefulWidget {
  final void Function(CartModel) onAddToOrders;

  const Foodpage({super.key, required this.onAddToOrders});

  @override
  State<Foodpage> createState() => _FoodpageState();
}

class _FoodpageState extends State<Foodpage> {
  List<RestorantsModel> restaurants = [];
  List<SellersModel> diets = [];
  List<PopularfoodModel> popularDiets = [];

  @override
  void initState() {
    super.initState();
    _getInitialInfo();
  }

  void _getInitialInfo() {
    setState(() {
      restaurants = RestorantsModel.getRestaurants();
      diets = SellersModel.getSellers();
      popularDiets = PopularfoodModel.getPopularDiets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildSearchField(),
          const SizedBox(height: 40),
          _buildRestaurantsSection(),
          const SizedBox(height: 40),
          _buildRecommendationSection(widget.onAddToOrders),
          const SizedBox(height: 40),
          _buildBestSellersSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection(void Function(CartModel) onAddToOrders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Recommendation\n',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: diets.length,
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemBuilder: (context, index) {
              return RecommendationItem(
                food: diets[index],
                onAddToOrders: onAddToOrders,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBestSellersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Best Sellers',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ListView.separated(
          shrinkWrap: true,
          itemCount: popularDiets.length,
          separatorBuilder: (context, index) => const SizedBox(height: 5),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            return BestSellerItem(
              sellers: popularDiets[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Search pancake',
          hintStyle: const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset('assets/icons/Search.svg'),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Mohieddine',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
    );
  }

  Widget _buildRestaurantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Restaurants',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 120,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RestoPage(restaurant: restaurants[index]),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: restaurants[index].boxColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(restaurants[index].iconPath),
                        ),
                      ),
                      Text(
                        restaurants[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RecommendationItem extends StatelessWidget {
  final SellersModel food;
  final void Function(CartModel) onAddToOrders;

  const RecommendationItem({
    super.key,
    required this.food,
    required this.onAddToOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: food.boxColor.withOpacity(0.3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(food.iconPath),
          Column(
            children: [
              Text(
                food.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                food.price,
                style: const TextStyle(
                  color: Color(0xff786F72),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              CartModel newOrder = CartModel(
                name: food.name,
                price: food.price, // Example price
                iconPath: food.iconPath,
                number: 1, // Start with 1 quantity
              );

              onAddToOrders(newOrder);
            },
            child: Container(
              height: 45,
              width: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    food.viewIsSelected
                        ? const Color(0xff9DCEFF)
                        : const Color.fromARGB(171, 237, 133, 225),
                    food.viewIsSelected
                        ? const Color(0xff92A3FD)
                        : const Color.fromARGB(146, 247, 0, 255),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  'Add',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BestSellerItem extends StatelessWidget {
  final PopularfoodModel sellers;

  const BestSellerItem({
    super.key,
    required this.sellers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: sellers.boxIsSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: sellers.boxIsSelected
            ? [
                BoxShadow(
                  color: const Color(0xff1D1617).withOpacity(0.07),
                  offset: const Offset(0, 10),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            sellers.iconPath,
            width: 65,
            height: 65,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sellers.name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                sellers.price,
                style: const TextStyle(
                    color: Color(0xff7B6F72),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              'assets/icons/button.svg',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
