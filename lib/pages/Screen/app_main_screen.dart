import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/pages/Screen/Profile_screen.dart';
import 'package:burger_app_full/pages/Screen/foood_app_home_screen.dart';
import 'package:burger_app_full/pages/Screen/cart_screen.dart';
import 'package:burger_app_full/service/cart_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();
  int currentPage = 0;
  final CartService cartService = CartService();

  final List<Widget> _pages = [
    FooodAppHomeScreen(),
    Scaffold(), // Heart page
    ProfileScreen(),
    CartScreen(), // Cart page
  ];

  @override
  void initState() {
    super.initState();
    cartService.initializeCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavitem(Iconsax.home_15, 'A', 0),
                  _buildNavitem(Iconsax.heart5, 'B', 1),
                  SizedBox(width: 60), // Space for center button
                  _buildNavitem(Icons.person_outline, 'C', 2),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildNavitem(Iconsax.shopping_cart, 'D', 3),
                      ListenableBuilder(
                        listenable: cartService,
                        builder: (context, child) {
                          if (cartService.itemCount > 0) {
                            return Positioned(
                              right: -7,
                              top: 16,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: red,
                                child: Text(
                                  '${cartService.itemCount}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Floating search button
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: GestureDetector(
              onTap: () {
                // Optional search action
              },
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 35,
                child: Icon(
                  CupertinoIcons.search,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavitem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: currentIndex == index ? red : Colors.black54,
          ),
          SizedBox(height: 5),
          CircleAvatar(
            radius: 3,
            backgroundColor: currentIndex == index ? red : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
