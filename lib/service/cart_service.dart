import 'dart:convert';
import 'package:burger_app_full/Core/models/cart_model.dart';
import 'package:burger_app_full/Core/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  Cart _cart = Cart();
  Cart get cart => _cart;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Initialize cart from storage
  Future<void> initializeCart() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cart');
      
      print('CartService: Initializing cart, stored data: $cartData');
      
      if (cartData != null) {
        final cartJson = json.decode(cartData);
        final items = (cartJson['items'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList();
        
        print('CartService: Loaded ${items.length} items from storage');
        
        _cart = Cart(
          items: items,
          promoCode: cartJson['promoCode'] ?? '',
          promoDiscount: (cartJson['promoDiscount'] ?? 0.0).toDouble(),
        );
      } else {
        print('CartService: No cart data found in storage, starting with empty cart');
      }
      _clearError();
    } catch (e) {
      print('CartService: Error loading cart: $e');
      _setError('Error loading cart: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Save cart to storage
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = {
        'items': _cart.items.map((item) => item.toJson()).toList(),
        'promoCode': _cart.promoCode,
        'promoDiscount': _cart.promoDiscount,
      };
      await prefs.setString('cart', json.encode(cartData));
      print('CartService: Cart saved with ${_cart.items.length} items');
    } catch (e) {
      print('CartService: Error saving cart: $e');
      _setError('Error saving cart: $e');
    }
  }

  // Add item to cart
  Future<bool> addToCart({
    required FoodModel product,
    int quantity = 1,
    List<String> selectedAddons = const [],
    String specialInstructions = '',
  }) async {
    try {
      _setLoading(true);
      
      // Check if item already exists in cart
      // Always create a unique ID for different products or addon combinations
      final existingItemIndex = _cart.items.indexWhere(
        (item) => item.product.id == product.id && 
                 listEquals(item.selectedAddons, selectedAddons),
      );

      print('CartService: Adding ${product.name}, existing index: $existingItemIndex');

      if (existingItemIndex != -1) {
        // Update quantity of existing item
        final existingItem = _cart.items[existingItemIndex];
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
        
        final updatedItems = List<CartItem>.from(_cart.items);
        updatedItems[existingItemIndex] = updatedItem;
        
        _cart = _cart.copyWith(items: updatedItems);
        print('CartService: Updated existing item, new quantity: ${updatedItem.quantity}');
      } else {
        // Add new item - use a more unique ID
        final cartItem = CartItem(
          id: '${product.id}_${product.name}_${DateTime.now().millisecondsSinceEpoch}',
          product: product,
          quantity: quantity,
          selectedAddons: selectedAddons,
          specialInstructions: specialInstructions,
          addedAt: DateTime.now(),
        );
        
        _cart = _cart.copyWith(items: [..._cart.items, cartItem]);
        print('CartService: Added new item: ${cartItem.id}, total items: ${_cart.items.length}');
      }

      await _saveCart();
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error adding to cart: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Remove item from cart
  Future<bool> removeFromCart(String itemId) async {
    try {
      _setLoading(true);
      
      final updatedItems = _cart.items.where((item) => item.id != itemId).toList();
      _cart = _cart.copyWith(items: updatedItems);
      
      await _saveCart();
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error removing from cart: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update item quantity
  Future<bool> updateQuantity(String itemId, int quantity) async {
    try {
      _setLoading(true);
      
      if (quantity <= 0) {
        return await removeFromCart(itemId);
      }

      final itemIndex = _cart.items.indexWhere((item) => item.id == itemId);
      if (itemIndex == -1) return false;

      final updatedItem = _cart.items[itemIndex].copyWith(quantity: quantity);
      final updatedItems = List<CartItem>.from(_cart.items);
      updatedItems[itemIndex] = updatedItem;
      
      _cart = _cart.copyWith(items: updatedItems);
      
      await _saveCart();
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error updating quantity: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Clear cart
  Future<bool> clearCart() async {
    try {
      _setLoading(true);
      
      _cart = Cart();
      
      await _saveCart();
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error clearing cart: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Apply promo code
  Future<bool> applyPromoCode(String code) async {
    try {
      _setLoading(true);
      
      // Mock promo code validation
      double discount = 0.0;
      switch (code.toUpperCase()) {
        case 'SAVE10':
          discount = 10.0;
          break;
        case 'SAVE20':
          discount = 20.0;
          break;
        case 'FIRSTORDER':
          discount = 15.0;
          break;
        case 'FREESHIP':
          discount = 5.0;
          break;
        default:
          _setError('Invalid promo code');
          return false;
      }
      
      _cart = _cart.copyWith(
        promoCode: code.toUpperCase(),
        promoDiscount: discount,
      );
      
      await _saveCart();
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error applying promo code: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Remove promo code
  Future<bool> removePromoCode() async {
    try {
      _setLoading(true);
      
      _cart = _cart.copyWith(
        promoCode: '',
        promoDiscount: 0.0,
      );
      
      await _saveCart();
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error removing promo code: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get cart item count
  int get itemCount => _cart.totalItems;

  // Get cart total
  double get total => _cart.total;

  // Check if product is in cart
  bool isInCart(String productId) {
    return _cart.items.any((item) => item.product.id == productId);
  }

  // Get quantity of product in cart
  int getProductQuantity(String productId) {
    return _cart.items
        .where((item) => item.product.id == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Mock checkout process
  Future<Map<String, dynamic>> processCheckout({
    required String deliveryAddress,
    required String paymentMethod,
    String? specialInstructions,
  }) async {
    try {
      _setLoading(true);
      
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));
      
      // Mock successful checkout
      final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
      final orderData = {
        'orderId': orderId,
        'items': _cart.items.map((item) => item.toJson()).toList(),
        'total': _cart.total,
        'deliveryAddress': deliveryAddress,
        'paymentMethod': paymentMethod,
        'specialInstructions': specialInstructions,
        'orderTime': DateTime.now().toIso8601String(),
        'estimatedDelivery': DateTime.now().add(Duration(minutes: 30)).toIso8601String(),
      };
      
      // Clear cart after successful checkout
      await clearCart();
      
      return {'success': true, 'order': orderData};
    } catch (e) {
      _setError('Checkout failed: $e');
      return {'success': false, 'error': e.toString()};
    } finally {
      _setLoading(false);
    }
  }
}