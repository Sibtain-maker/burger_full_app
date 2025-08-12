import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/Core/models/categories_model.dart';
import 'package:burger_app_full/Core/models/product_model.dart';
import 'package:burger_app_full/Core/models/user_profile_model.dart';
import 'package:burger_app_full/service/profile_service.dart';
import 'package:burger_app_full/widgets/products_items_dispaly.dart';
import 'package:burger_app_full/widgets/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:burger_app_full/pages/Screen/view_all_screen.dart';

class FooodAppHomeScreen extends StatefulWidget {
  const FooodAppHomeScreen({super.key});

  @override
  State<FooodAppHomeScreen> createState() => _FooodAppHomeScreenState();
}

class _FooodAppHomeScreenState extends State<FooodAppHomeScreen> {
  late Future<List<CategoryModel>> futureCategories = fetchCategories();
  late Future<List<FoodModel>> futureFoodproducts = Future.value([]);
  List<CategoryModel> categories = [];
  String? selectedCategory;
  final ProfileService _profileService = ProfileService();
  UserProfileModel? userProfile;
  @override
  void initState() {
    super.initState();
    _initializedata();
    _loadUserProfile();
  }

  void _initializedata() async {
    try {
      final categories = await futureCategories;
      if (categories.isNotEmpty) {
        setState(() {
          this.categories = categories;
          selectedCategory =
              categories.first.name; // Set the first category as selected
          futureFoodproducts = fetchfoodproducts(selectedCategory!);
        });
      }
    } catch (error) {
      print('Error initializing data: $error');
    }
  }

  void _loadUserProfile() async {
    try {
      final profile = await _profileService.getCurrentUserProfile();
      if (profile != null) {
        setState(() {
          userProfile = profile;
        });
      }
    } catch (error) {
      print('Error loading user profile: $error');
    }
  }

  // Fetch Food products
  Future<List<FoodModel>> fetchfoodproducts(String category) async {
    try {
      final response = await Supabase.instance.client
          .from('food_products')
          .select()
          .ilike('category', category.trim()); // Case-insensitive match
      final products = (response as List)
          .map((json) {
            print('Supabase product data: $json'); // Debug print
            final product = FoodModel.fromJson(json);
            print('Created product: ID=${product.id}, Name=${product.name}'); // Debug print
            return product;
          })
          .toList();
      return products;
    } catch (error) {
      print('Error fetching products: $error');
      return [];
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
          SizedBox(height: 20), // 👈 Added space after categories
          viewAll(),
          SizedBox(height: 20),
          _buildproductsection(),
        ],
      ),
    );
  }

  Widget _buildproductsection() {
    return Container(
      height: 300, // Increased height for bigger burgers
      child: FutureBuilder<List<FoodModel>>(
        future: futureFoodproducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error : ${snapshot.error}'));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return Center(child: Text('No products Found'));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: 20),
                width: 180, // Bigger width for burger cards
                child: ProductsItemsDispaly(foodModel: products[index]),
              );
            },
          );
        },
      ),
    );
  }

  Padding viewAll() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Popular Now',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAllScreen()),
              );
            },
            child: Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
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
                    handleCategorySelection(category.name);
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
                        SmartImage(
                          imagePath: category.image,
                          height: 30,
                          width: 30,
                        ),
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

  void handleCategorySelection(String category) {
    if (selectedCategory == category) return;
    setState(() {
      selectedCategory = category;
      futureFoodproducts = fetchfoodproducts(category);
    });
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
    String locationText = 'Kathmandu, Nepal'; // Default fallback
    
    if (userProfile != null) {
      if (userProfile!.city != null && userProfile!.country != null) {
        locationText = '${userProfile!.city}, ${userProfile!.country}';
      } else if (userProfile!.city != null) {
        locationText = userProfile!.city!;
      } else if (userProfile!.address != null && userProfile!.address!.isNotEmpty) {
        locationText = userProfile!.address!;
      }
    }
    
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
        children: [
          Icon(Iconsax.location, color: Colors.red, size: 18),
          SizedBox(width: 4),
          Text(
            locationText,
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
          child: SizedBox(
            height: 45,
            width: 45,
            child: Image.asset('assets/food-delivery/profile.png'),
          ),
        ),
      ],
    );
  }
}
