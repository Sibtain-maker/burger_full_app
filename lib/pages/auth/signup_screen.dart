import 'package:burger_app_full/widgets/my_button.dart';
import 'package:flutter/material.dart';

class Signup_screen extends StatefulWidget {
  const Signup_screen({super.key});

  @override
  State<Signup_screen> createState() => _Signup_screenState();
}

class _Signup_screenState extends State<Signup_screen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/login.jpg',
                width: double.maxFinite,
                height: 500,
              ),
              // input text field for email
              TextField(
                controller: emailcontroller,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordcontroller,
                decoration: InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                child: MyButton(onPressed: () {}, buttonText: 'SIGN UP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
