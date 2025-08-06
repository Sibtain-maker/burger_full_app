import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/Core/models/categories_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FooodAppHomeScreen extends StatefulWidget {
  const FooodAppHomeScreen({super.key});

  @override
  State<FooodAppHomeScreen> createState() => _FooodAppHomeScreenState();
}

class _FooodAppHomeScreenState extends State<FooodAppHomeScreen> {
  late Future<List<CategoryModel>> futureCategories = fetchCategories();
  List<CategoryModel> categories = [];
  String? selectedCategory;
  @override
  void initState() {
    super.initState();
    _initializedata();
  }

  void _initializedata() async {
    try {
      final categories = await futureCategories;
      if (categories.isNotEmpty) {
        setState(() {
          this.categories = categories;
          selectedCategory =
              categories.first.name; // Set the first category as selected
        });
      }
    } catch (error) {
      print('Error initializing data: $error');
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await Supabase.instance.client
          .from('Category_items')
          .select();
      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (error) {
      print('Error fetching categories: $error');
      return [];
    }
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
          Padding(
            padding: const EdgeInsets.all(17),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _buildCatogariesList(),
        ],
      ),
    );
  }

  Widget _buildCatogariesList() {
    return FutureBuilder(
      future: futureCategories,

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox.shrink();
        }
        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 16 : 0, right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category.name;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedCategory == category.name
                          ? Colors.red.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: selectedCategory == category.name
                            ? Colors.red
                            : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.network(category.image, height: 30, width: 30),
                        SizedBox(width: 8),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: selectedCategory == category.name
                                ? Colors.red
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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
