import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/Core/models/product_model.dart';
import 'package:burger_app_full/service/memory_favorites_service.dart';
import 'package:burger_app_full/widgets/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final MemoryFavoritesService favoritesService = MemoryFavoritesService();
  List<FoodModel> favoriteProducts = [];
  List<String> favoriteProductIds = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload favorites when screen becomes visible
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Get favorites from in-memory service
      favoriteProducts = favoritesService.getFavoriteProducts();
      favoriteProductIds = favoritesService.getFavoriteIds();

      print('Loaded ${favoriteProducts.length} favorites from memory');
    } catch (e) {
      print('Error loading favorites: $e');
      error = 'Error loading favorites: $e';
      favoriteProducts = [];
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _toggleFavorite(FoodModel product) {
    // Toggle using in-memory service
    favoritesService.toggleFavorite(product);

    // Reload the favorites list
    _loadFavorites();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated favorites'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Debug: Add test product button
          IconButton(
            icon: Icon(Iconsax.add, color: Colors.blue),
            onPressed: () {
              final testProduct = FoodModel(
                id: 'test_burger',
                imageCard: 'assets/food-delivery/product/beef_burger.png',
                imageDetail: 'assets/food-delivery/product/beef_burger1.png',
                name: 'Test Burger',
                price: 9.99,
                rate: 4.5,
                specialItems: 'Test Special',
                category: 'Burger',
                kcal: 500,
                time: '15 min',
              );
              favoritesService.addToFavorites(testProduct);
              _loadFavorites();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added test product to favorites')),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: red),
            SizedBox(height: 16),
            Text(
              'Loading your favorites...',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return _buildErrorState();
    }

    if (favoriteProducts.isEmpty) {
      return _buildEmptyState();
    }

    return _buildFavoritesList();
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.warning_2, size: 64, color: Colors.orange),
            SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              error ?? 'Unknown error occurred',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loadFavorites,
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.refresh),
                  SizedBox(width: 8),
                  Text('Try Again'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.heart, size: 80, color: Colors.grey[400]),
            SizedBox(height: 24),
            Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Start adding items to your favorites by tapping the fire icon on products you love!',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            // Debug information
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Debug Info:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Favorites count: ${favoritesService.favoritesCount}'),
                  Text('Favorite IDs: ${favoritesService.getFavoriteIds()}'),
                ],
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.shop, color: red),
                  SizedBox(width: 8),
                  Text(
                    'Use Home tab to browse products',
                    style: TextStyle(
                      color: red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    return RefreshIndicator(
      color: red,
      onRefresh: _loadFavorites,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: _buildFavoriteItem(product),
          );
        },
      ),
    );
  }

  Widget _buildFavoriteItem(FoodModel product) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SmartImage(
                imagePath: product.imageCard,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Product Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        product.category,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Delete Button
          Padding(
            padding: EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () => _toggleFavorite(product),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Iconsax.trash, color: red, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
