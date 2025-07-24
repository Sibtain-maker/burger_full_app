import 'package:burger_app_full/pages/auth/login_screen.dart';
import 'package:burger_app_full/service/auth_service.dart';
import 'package:burger_app_full/widgets/my_button.dart';
import 'package:burger_app_full/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

class Signup_screen extends StatefulWidget {
  const Signup_screen({super.key});

  @override
  State<Signup_screen> createState() => _Signup_screenState();
}

class _Signup_screenState extends State<Signup_screen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final AuthService authService = AuthService();
  bool isloadin = false;
  // validate Email Formate
  void signUp() async {
    String email = emailcontroller.text;
    String password = passwordcontroller.text;

    if (!email.contains('.com')) {
      showsnackBar(context, 'Please enter a valid email');
      return;
    }
    setState(() {
      isloadin = true;
    });
    final result = await authService.signUp(email, password);
    setState(() {
      isloadin = false;
    });
    if (result == null) {
      showsnackBar(context, 'Sign up successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      showsnackBar(context, 'Sign up failed: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
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
                isloadin
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.maxFinite,
                        child: MyButton(
                          onPressed: signUp,

                          buttonText: 'SIGN UP',
                        ),
                      ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        ' Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
