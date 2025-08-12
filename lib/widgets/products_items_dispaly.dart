import 'package:burger_app_full/Core/models/product_model.dart';
import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/pages/Screen/Food_detail_screen.dart';
import 'package:burger_app_full/service/cart_service.dart';
import 'package:burger_app_full/service/memory_favorites_service.dart';
import 'package:burger_app_full/widgets/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductsItemsDispaly extends StatefulWidget {
  final FoodModel foodModel;
  const ProductsItemsDispaly({super.key, required this.foodModel});

  @override
  State<ProductsItemsDispaly> createState() => _ProductsItemsDispalyState();
}

class _ProductsItemsDispalyState extends State<ProductsItemsDispaly> {
  final CartService cartService = CartService();
  final MemoryFavoritesService favoritesService = MemoryFavoritesService();
  bool isLoading = false;
  bool isFavorite = false;
  bool isTogglingFavorite = false;
  
  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }
  
  void _checkFavoriteStatus() {
    if (mounted) {
      setState(() {
        isFavorite = favoritesService.isFavorite(widget.foodModel.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailScreen(foodModel: widget.foodModel),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            // Add flame icon for hot items
            Stack(
              children: [
                SmartImage(
                  imagePath: widget.foodModel.imageCard,
                  height: 90,
                  width: 110,
                  fit: BoxFit.contain,
                ),
                Positioned(
                  top: 0,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isFavorite ? Colors.red : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isFavorite ? null : Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isTogglingFavorite
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: isFavorite ? Colors.white : Colors.red,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              Icons.local_fire_department,
                              color: isFavorite ? Colors.white : Colors.red,
                              size: 16,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.foodModel.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.foodModel.specialItems,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: '\$',
                    style: TextStyle(fontSize: 16, color: Colors.orange),
                  ),
                  TextSpan(
                    text: ' ${widget.foodModel.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 22, color: Colors.orange),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            // Add to cart button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Iconsax.shopping_cart, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart() async {
    setState(() => isLoading = true);
    
    try {
      final success = await cartService.addToCart(
        product: widget.foodModel,
        quantity: 1,
      );
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Iconsax.tick_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('${widget.foodModel.name} added to cart!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add item to cart'),
            backgroundColor: red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  
  void _toggleFavorite() {
    if (isTogglingFavorite) return;
    
    setState(() => isTogglingFavorite = true);
    
    // Toggle favorite status using in-memory service
    final newStatus = favoritesService.toggleFavorite(widget.foodModel);
    
    if (mounted) {
      setState(() {
        isFavorite = newStatus;
        isTogglingFavorite = false;
      });
      
      // Show feedback to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isFavorite ? Iconsax.heart5 : Iconsax.heart,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                isFavorite 
                  ? '${widget.foodModel.name} added to favorites!' 
                  : '${widget.foodModel.name} removed from favorites!'
              ),
            ],
          ),
          backgroundColor: isFavorite ? Colors.red : Colors.grey[700],
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
