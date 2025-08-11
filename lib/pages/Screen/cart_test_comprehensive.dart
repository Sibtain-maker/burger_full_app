import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/Core/models/product_model.dart';
import 'package:burger_app_full/service/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CartTestComprehensive extends StatefulWidget {
  const CartTestComprehensive({super.key});

  @override
  State<CartTestComprehensive> createState() => _CartTestComprehensiveState();
}

class _CartTestComprehensiveState extends State<CartTestComprehensive> {
  final CartService cartService = CartService();

  // Test products with different categories and unique IDs
  final List<FoodModel> testProducts = [
    // Burgers
    FoodModel(
      id: 'burger_001',
      imageCard: 'assets/food-delivery/product/beef_burger.png',
      imageDetail: 'assets/food-delivery/product/beef_burger1.png',
      name: 'Beef Burger',
      price: 7.99,
      rate: 4.5,
      specialItems: 'Juicy beef patty with cheese 🍔',
      category: 'Burger',
      kcal: 450,
      time: '15 min',
    ),
    FoodModel(
      id: 'burger_002',
      imageCard: 'assets/food-delivery/product/bacon_burger.png',
      imageDetail: 'assets/food-delivery/product/bacon_burger1.png',
      name: 'Bacon Burger',
      price: 9.99,
      rate: 4.8,
      specialItems: 'Crispy bacon with beef patty 🥓',
      category: 'Burger',
      kcal: 520,
      time: '18 min',
    ),
    FoodModel(
      id: 'burger_003',
      imageCard: 'assets/food-delivery/product/cheese-burger.png',
      imageDetail: 'assets/food-delivery/product/cheese-burger1.png',
      name: 'Cheese Burger',
      price: 8.49,
      rate: 4.6,
      specialItems: 'Extra cheese with beef patty 🧀',
      category: 'Burger',
      kcal: 480,
      time: '16 min',
    ),
    // Pizza
    FoodModel(
      id: 'pizza_001',
      imageCard: 'assets/food-delivery/product/pizza.png',
      imageDetail: 'assets/food-delivery/product/pizza1.png',
      name: 'Supreme Pizza',
      price: 12.99,
      rate: 4.7,
      specialItems: 'Loaded with toppings 🍕',
      category: 'Pizza',
      kcal: 650,
      time: '25 min',
    ),
    // Dessert
    FoodModel(
      id: 'dessert_001',
      imageCard: 'assets/food-delivery/product/cup_cake.png',
      imageDetail: 'assets/food-delivery/product/cup-cake1.png',
      name: 'Chocolate Cupcake',
      price: 3.99,
      rate: 4.3,
      specialItems: 'Rich chocolate with frosting 🧁',
      category: 'Dessert',
      kcal: 280,
      time: '5 min',
    ),
  ];

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
        title: Text('Cart Test - Multiple Products'),
        backgroundColor: red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => cartService.initializeCart(),
          ),
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () => cartService.clearCart(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Products Section
          Container(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Available Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: testProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(testProducts[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          Divider(thickness: 2),
          
          // Cart Section
          Expanded(
            child: ListenableBuilder(
              listenable: cartService,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cart Items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${cartService.itemCount} items',
                              style: TextStyle(
                                color: red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (cartService.cart.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No items in cart', style: TextStyle(fontSize: 16, color: Colors.grey)),
                              SizedBox(height: 16),
                              Text('Add products above to test cart functionality', 
                                   style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: cartService.cart.items.length,
                          itemBuilder: (context, index) {
                            return _buildCartItem(cartService.cart.items[index]);
                          },
                        ),
                      ),
                    
                    // Order Summary
                    if (cartService.cart.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(top: BorderSide(color: Colors.grey[300]!)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Subtotal:', style: TextStyle(fontSize: 14)),
                                Text('\$${cartService.cart.subtotal.toStringAsFixed(2)}'),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tax:', style: TextStyle(fontSize: 14)),
                                Text('\$${cartService.cart.tax.toStringAsFixed(2)}'),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery:', style: TextStyle(fontSize: 14)),
                                Text('\$${cartService.cart.deliveryFee.toStringAsFixed(2)}'),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('\$${cartService.cart.total.toStringAsFixed(2)}', 
                                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: red)),
                              ],
                            ),
                          ],
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

  Widget _buildProductCard(FoodModel product) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: imagebackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                product.imageCard,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: imagebackground,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(product.category),
                          size: 40,
                          color: red,
                        ),
                        SizedBox(height: 4),
                        Text(
                          _getCategoryEmoji(product.category),
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.specialItems,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: red,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _addToCart(product),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: imagebackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.product.imageCard,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: imagebackground,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_getCategoryIcon(item.product.category), color: red, size: 20),
                        Text(_getCategoryEmoji(item.product.category), style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          
          SizedBox(width: 12),
          
          // Product Details
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
                  item.product.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)} each',
                  style: TextStyle(
                    fontSize: 14,
                    color: red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Controls
          Row(
            children: [
              GestureDetector(
                onTap: () => cartService.updateQuantity(item.id, item.quantity - 1),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: grey1,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.remove, size: 16, color: red),
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${item.quantity}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () => cartService.updateQuantity(item.id, item.quantity + 1),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.add, size: 16, color: red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart(FoodModel product) async {
    final success = await cartService.addToCart(product: product, quantity: 1);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'burger':
        return Icons.lunch_dining;
      case 'pizza':
        return Icons.local_pizza;
      case 'dessert':
        return Icons.cake;
      default:
        return Icons.fastfood;
    }
  }

  String _getCategoryEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'burger':
        return '🍔';
      case 'pizza':
        return '🍕';
      case 'dessert':
        return '🧁';
      default:
        return '🍽️';
    }
  }
}