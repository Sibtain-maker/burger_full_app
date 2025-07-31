import 'package:flutter/material.dart';
import 'package:burger_app_full/Core/Utils/const.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background with pattern
          Container(
            height: size.height,
            width: size.width,
            color: imagebackground,
            child: Image.asset(
              'assets/food-delivery/food pattern.png',
              color: imagebackground2,
              repeat: ImageRepeat.repeatY,
              fit: BoxFit.cover,
            ),
          ),

          // Chef Image
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/food-delivery/chef.png',
              height: 400,
              fit: BoxFit.contain,
            ),
          ),

          // Floating vegetables/fruits
          Positioned(
            top: 150,
            right: 40,
            child: Image.asset('assets/food-delivery/leaf.png', width: 60),
          ),
          Positioned(
            top: 400,
            right: 40,
            child: Image.asset('assets/food-delivery/chili.png', width: 60),
          ),
          // Add more if needed: tomato.png, bell_pepper.png, etc.

          // Bottom white container with text
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: 'The Fastest In\nDelivery '),
                        TextSpan(
                          text: 'Food',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
