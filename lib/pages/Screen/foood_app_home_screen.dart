import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/Core/models/categories_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FooodAppHomeScreen extends StatefulWidget {
  const FooodAppHomeScreen({super.key});

  @override
  State<FooodAppHomeScreen> createState() => _FooodAppHomeScreenState();
}

class _FooodAppHomeScreenState extends State<FooodAppHomeScreen> {
  late Future<List<CategoryModel>> futureCategories = fetchCategories();
  Future<List<CategoryModel>> fetchCategories() async {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarparts(),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20), // 👈 Added space at the top
          // 👇 Added horizontal padding here
          banner(),
          SizedBox(height: 20), // 👈 Added space after the banner
          Text(
            'Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      _buildCatogariesList,
    );
  }

  Widget _buildCatogariesList() {
    return SizedBox();
  }

  Padding banner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: imagebackground2,
        ),
        padding: EdgeInsets.only(top: 25, right: 25, left: 25),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: 'The Fastest in Delivery',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: ' Food',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    child: Text(
                      'Order Now', // 🔠 Capitalized text
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset('assets/food-delivery/courier.png'),
          ],
        ),
      ),
    );
  }

  AppBar AppBarparts() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        height: 45,
        width: 45,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset('assets/food-delivery/icon/dash.png'),
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Iconsax.location, color: Colors.red, size: 18),
          SizedBox(width: 4),
          Text(
            'Kathmandu, Nepal', // 🔄 Updated title text
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.orange,
            size: 20,
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            height: 45,
            width: 45,
            child: Image.asset('assets/food-delivery/profile.png'),
          ),
        ),
      ],
    );
  }
}
