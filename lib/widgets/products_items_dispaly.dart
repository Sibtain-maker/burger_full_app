import 'package:burger_app_full/Core/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductsItemsDispaly extends StatefulWidget {
  final FoodModel foodModel;
  const ProductsItemsDispaly({super.key, required this.foodModel});

  @override
  State<ProductsItemsDispaly> createState() => _ProductsItemsDispalyState();
}

class _ProductsItemsDispalyState extends State<ProductsItemsDispaly> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                Image.network(
                  widget.foodModel.imageCard,
                  height: 90,
                  width: 110,
                  fit: BoxFit.contain,
                ),
                Positioned(
                  top: 0,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 16,
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
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
