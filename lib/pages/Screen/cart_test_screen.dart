import 'package:burger_app_full/Core/models/cart_model.dart';
import 'package:burger_app_full/Core/models/product_model.dart';
import 'package:burger_app_full/service/cart_service.dart';
import 'package:flutter/material.dart';

class CartTestScreen extends StatefulWidget {
  const CartTestScreen({super.key});

  @override
  State<CartTestScreen> createState() => _CartTestScreenState();
}

class _CartTestScreenState extends State<CartTestScreen> {
  final CartService cartService = CartService();

  @override
  void initState() {
    super.initState();
    _addTestItems();
  }

  Future<void> _addTestItems() async {
    await cartService.initializeCart();
    
    // Add some test products
    final testProducts = [
      FoodModel(
        id: '1',
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
        id: '2',
        imageCard: 'assets/food-delivery/product/pizza.png',
        imageDetail: 'assets/food-delivery/product/pizza1.png',
        name: 'Pizza Supreme',
        price: 12.99,
        rate: 4.8,
        specialItems: 'Loaded with toppings',
        category: 'Pizza',
        kcal: 650,
        time: '20 min',
      ),
      FoodModel(
        id: '3',
        imageCard: 'assets/food-delivery/product/cup_cake.png',
        imageDetail: 'assets/food-delivery/product/cup-cake1.png',
        name: 'Cupcake Delight',
        price: 3.99,
        rate: 4.2,
        specialItems: 'Sweet and fluffy',
        category: 'Dessert',
        kcal: 280,
        time: '5 min',
      ),
    ];

    for (final product in testProducts) {
      await cartService.addToCart(product: product, quantity: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Test'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              cartService.clearCart();
              _addTestItems();
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: cartService,
        builder: (context, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Cart Items: ${cartService.itemCount}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cartService.cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cartService.cart.items[index];
                    return ListTile(
                      leading: Image.asset(
                        item.product.imageCard,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            child: Icon(Icons.error),
                          );
                        },
                      ),
                      title: Text(item.product.name),
                      subtitle: Text('\$${item.product.price} x ${item.quantity}'),
                      trailing: Text('\$${item.itemTotalPrice.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                  child: Text('Go to Cart Screen'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}