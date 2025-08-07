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
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        width: size.width * 0.45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              spreadRadius: 2,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Image.network(
              widget.foodModel.imageCard,
              height: 90,
              width: 110,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 12),
            Text(
              widget.foodModel.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              widget.foodModel.specialItems,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: '\$',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  TextSpan(
                    text: ' ${widget.foodModel.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 24, color: Colors.black),
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
