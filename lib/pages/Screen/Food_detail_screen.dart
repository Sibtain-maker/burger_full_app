import 'package:burger_app_full/Core/models/product_model.dart';
import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/widgets/smart_image.dart';
import 'package:flutter/material.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodModel foodModel;
  const FoodDetailScreen({super.key, required this.foodModel});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int quantity = 1;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: imagebackground2, // Using the background color from utils
        ),
        child: Stack(
          children: [
            // Background pattern with color filter
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  orange.withValues(
                    alpha: 0.1,
                  ), // Using orange color with low opacity
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/food-delivery/food pattern.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Main content
            Column(
              children: [
                // Top section with navigation buttons and burger image
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      // Navigation buttons
                      Positioned(
                        top: 50,
                        left: 20,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
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
                      ),
                      // Burger image
                      Center(
                        child: SmartImage(
                          imagePath: widget.foodModel.imageDetail,
                          height: 300,
                          width: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom white card with product details
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quantity selector
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Product name and price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.foodModel.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\$',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${widget.foodModel.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // Subtitle
                        Text(
                          widget.foodModel.specialItems,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Product attributes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildAttribute(
                              Icons.star,
                              '${widget.foodModel.rate}',
                              orange,
                            ),
                            _buildAttribute(
                              Icons.local_fire_department,
                              '${widget.foodModel.kcal} Kcal',
                              red,
                            ),
                            _buildAttribute(
                              Icons.access_time,
                              widget.foodModel.time,
                              red,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Description with Read More functionality
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isExpanded
                                  ? 'This ${widget.foodModel.name.toLowerCase()} uses 100% quality ingredients with fresh vegetables and premium toppings. Made with care and served hot for the best dining experience. Our ${widget.foodModel.name.toLowerCase()} features a perfectly grilled patty, fresh lettuce, ripe tomatoes, crisp onions, and our signature sauce. Each bite delivers a burst of flavor that will satisfy your cravings. We source only the finest ingredients and prepare each ${widget.foodModel.name.toLowerCase()} fresh to order, ensuring maximum taste and quality. Perfect for lunch, dinner, or anytime you want a delicious meal.'
                                  : 'This ${widget.foodModel.name.toLowerCase()} uses 100% quality ingredients with fresh vegetables and premium toppings. Made with care and served hot for the best dining experience...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Text(
                                isExpanded ? 'Read Less' : 'Read More',
                                style: TextStyle(
                                  color: red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        // Add to cart button
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20), // Extra padding at bottom
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttribute(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
