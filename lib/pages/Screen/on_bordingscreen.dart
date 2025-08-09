import 'package:burger_app_full/Core/models/on_bording_model.dart';
import 'package:burger_app_full/pages/Screen/Profile_screen.dart';
import 'package:burger_app_full/pages/Screen/app_main_screen.dart';
import 'package:burger_app_full/pages/Screen/foood_app_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:burger_app_full/Core/Utils/const.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        //for image background
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: imagebackground,
            child: Image.asset(
              'assets/food-delivery/food pattern.png',
              color: imagebackground2,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          Positioned(
            top: -50,
            left: 0,
            right: 0,
            child: Image.asset('assets/food-delivery/chef.png'),
          ),
          Positioned(
            top: 150,

            right: 40,
            child: Image.asset('assets/food-delivery/leaf.png', width: 80),
          ),
          Positioned(
            top: 400,

            right: 40,
            child: Image.asset('assets/food-delivery/chili.png', width: 80),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CustoumClipper(),
              // clipper: YourCustomClipper(), // Optional: add if you want a curved effect
              child: Container(
                color: Colors.white, // <-- This makes the surface white
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 150,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: data.length,
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: data[index]['title1'],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: data[index]['title2'],
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                data[index]['description']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        data.length,
                        (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: currentPage == index ? 20 : 10,
                          height: 10,
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? Colors.orange
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppMainScreen(),
                          ),
                        );
                      },
                      color: Colors.red,
                      height: 65,
                      minWidth: 250,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustoumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 30);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 30);
    path.quadraticBezierTo(size.width / 2, -30, 0, 30);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
