import 'package:burger_app_full/Core/models/product_model.dart';

/// Simple in-memory favorites service
/// Stores favorites in memory during app session
class MemoryFavoritesService {
  static final MemoryFavoritesService _instance = MemoryFavoritesService._internal();
  factory MemoryFavoritesService() => _instance;
  MemoryFavoritesService._internal();

  // In-memory storage
  final Set<String> _favoriteIds = <String>{};
  final Map<String, FoodModel> _favoriteProducts = <String, FoodModel>{};

  /// Check if a product is favorite
  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  /// Add product to favorites
  void addToFavorites(FoodModel product) {
    _favoriteIds.add(product.id);
    _favoriteProducts[product.id] = product;
    print('Added to favorites: ${product.name} (${product.id})');
    print('Total favorites: ${_favoriteIds.length}');
  }

  /// Remove product from favorites
  void removeFromFavorites(String productId) {
    _favoriteIds.remove(productId);
    final product = _favoriteProducts.remove(productId);
    print('Removed from favorites: ${product?.name ?? productId}');
    print('Total favorites: ${_favoriteIds.length}');
  }

  /// Toggle favorite status
  bool toggleFavorite(FoodModel product) {
    if (isFavorite(product.id)) {
      removeFromFavorites(product.id);
      return false;
    } else {
      addToFavorites(product);
      return true;
    }
  }

  /// Get all favorite products
  List<FoodModel> getFavoriteProducts() {
    return _favoriteProducts.values.toList();
  }

  /// Get favorite product IDs
  List<String> getFavoriteIds() {
    return _favoriteIds.toList();
  }

  /// Clear all favorites
  void clearFavorites() {
    _favoriteIds.clear();
    _favoriteProducts.clear();
    print('Cleared all favorites');
  }

  /// Get favorites count
  int get favoritesCount => _favoriteIds.length;
}