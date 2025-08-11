import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/Core/models/product_model.dart';
import 'package:burger_app_full/service/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleCartScreen extends StatefulWidget {
  const SimpleCartScreen({super.key});

  @override
  State<SimpleCartScreen> createState() => _SimpleCartScreenState();
}

class _SimpleCartScreenState extends State<SimpleCartScreen> {
  final CartService cartService = CartService();

  @override
  void initState() {
    super.initState();
    cartService.initializeCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => cartService.initializeCart(),
          ),
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              // Clear cart storage for debugging
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('cart');
              cartService.initializeCart();
            },
          ),
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: _addTestItems,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: cartService,
        builder: (context, child) {
          print('Cart screen rebuilding. Items: ${cartService.cart.items.length}');
          
          if (cartService.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (cartService.cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your cart is empty', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${cartService.itemCount} items', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cartService.cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cartService.cart.items[index];
                    return Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: imagebackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: item.product.imageCard.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      item.product.imageCard,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Icon(Icons.fastfood, color: red),
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.fastfood, color: red),
                                  ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item.product.specialItems,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '\$${item.itemTotalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => cartService.updateQuantity(item.id, item.quantity - 1),
                                icon: Icon(Icons.remove, color: red),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${item.quantity}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                onPressed: () => cartService.updateQuantity(item.id, item.quantity + 1),
                                icon: Icon(Icons.add, color: red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 120), // Extra bottom padding for nav bar
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal:', style: TextStyle(fontSize: 16)),
                        Text('\$${cartService.cart.subtotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('\$${cartService.cart.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: red)),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Checkout - Coming Soon!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => cartService.clearCart(),
        backgroundColor: red,
        child: Icon(Icons.clear_all, color: Colors.white),
      ),
    );
  }

  Future<void> _addTestItems() async {
    // Add test products with different IDs
    final testProducts = [
      FoodModel(
        id: 'beef_burger_001',
        imageCard: 'assets/food-delivery/product/beef_burger.png',
        imageDetail: 'assets/food-delivery/product/beef_burger1.png',
        name: 'Beef Burger',
        price: 7.99,
        rate: 4.5,
        specialItems: 'Juicy beef patty with cheese',
        category: 'Burger',
        kcal: 450,
        time: '15 min',
      ),
      FoodModel(
        id: 'bacon_burger_002',
        imageCard: 'assets/food-delivery/product/bacon_burger.png',
        imageDetail: 'assets/food-delivery/product/bacon_burger1.png',
        name: 'Bacon Burger',
        price: 9.99,
        rate: 4.8,
        specialItems: 'Crispy bacon with beef patty',
        category: 'Burger',
        kcal: 520,
        time: '18 min',
      ),
      FoodModel(
        id: 'cheese_burger_003',
        imageCard: 'assets/food-delivery/product/cheese-burger.png',
        imageDetail: 'assets/food-delivery/product/cheese-burger1.png',
        name: 'Cheese Burger',
        price: 8.49,
        rate: 4.6,
        specialItems: 'Extra cheese with beef patty',
        category: 'Burger',
        kcal: 480,
        time: '16 min',
      ),
    ];

    for (final product in testProducts) {
      await cartService.addToCart(product: product, quantity: 1);
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added 3 test items to cart')),
      );
    }
  }
}