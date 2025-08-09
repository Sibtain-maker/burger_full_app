import 'package:burger_app_full/Core/models/product_model.dart';
import 'package:burger_app_full/widgets/products_items_dispaly.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewAllScreen extends StatefulWidget {
  const ViewAllScreen({super.key});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  late Future<List<FoodModel>> futureFoodproducts;
  List<FoodModel> allProducts = [];
  String selectedCategory = 'All';

  // Fetch all available categories from database
  Future<List<String>> fetchAvailableCategories() async {
    try {
      final response = await Supabase.instance.client
          .from('food_products')
          .select('category');

      Set<String> categories = {};
      for (var item in response) {
        if (item['category'] != null) {
          categories.add(item['category'].toString());
        }
      }
      return categories.toList();
    } catch (error) {
      print('Error fetching categories: $error');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    futureFoodproducts = fetchAllProducts();
    // Debug: Print available categories
    fetchAvailableCategories().then((categories) {
      print('Available categories in database: $categories');
    });
  }

  // Fetch all food products
  Future<List<FoodModel>> fetchAllProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('food_products')
          .select();
      return (response as List)
          .map((json) => FoodModel.fromJson(json))
          .toList();
    } catch (error) {
      print('Error fetching products: $error');
      return [];
    }
  }

  // Fetch products by category
  Future<List<FoodModel>> fetchProductsByCategory(String category) async {
    if (category == 'All') {
      return fetchAllProducts();
    }

    try {
      final response = await Supabase.instance.client
          .from('food_products')
          .select()
          .ilike('category', category.trim());
      return (response as List)
          .map((json) => FoodModel.fromJson(json))
          .toList();
    } catch (error) {
      print('Error fetching products by category: $error');
      return [];
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      futureFoodproducts = fetchProductsByCategory(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        centerTitle: true,
        title: Text(
          'All Products',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          // Add header with product count and sort
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<List<FoodModel>>(
                  future: futureFoodproducts,
                  builder: (context, snapshot) {
                    final count = snapshot.data?.length ?? 0;
                    return Text(
                      '$count Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    Icon(Icons.sort, color: Colors.grey, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Sort by',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          // Add filter chips
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder<List<String>>(
              future: fetchAvailableCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 40,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final categories = snapshot.data ?? [];
                if (categories.isEmpty) {
                  return SizedBox(
                    height: 40,
                    child: Center(child: Text('No categories found')),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', selectedCategory == 'All'),
                      SizedBox(width: 8),
                      ...categories
                          .map(
                            (category) => Row(
                              children: [
                                SizedBox(width: 8),
                                _buildFilterChip(
                                  category,
                                  selectedCategory == category,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<FoodModel>>(
              future: futureFoodproducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return Center(child: Text('No products found'));
                }

                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductsItemsDispaly(
                            foodModel: products[index],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => _onCategorySelected(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
