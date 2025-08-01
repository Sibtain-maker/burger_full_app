import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/pages/Screen/Profile_screen.dart';
import 'package:burger_app_full/pages/Screen/foood_app_home_screen.dart';
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
  @override
  PageController _pageController = PageController();
  int currentPage = 0;
  final List<Widget> _pages = [
    FooodAppHomeScreen(),
    Scaffold(), // Heart page
    ProfileScreen(),
    Scaffold(), // Cart page (add your cart screen here)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            _buildNavitem(Iconsax.home_15, 'A', 0),
            SizedBox(width: 10),
            _buildNavitem(Iconsax.heart5, 'B', 1),
            _buildNavitem(Icons.person_outline, 'C', 2),
            SizedBox(width: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildNavitem(Iconsax.shopping_cart, 'D', 3),
                Positioned(
                  right: -7,
                  top: 16,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: red,
                    child: Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 155,
                  top: -27,
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  // helper methood to build navigation bar items
  Widget _buildNavitem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
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
