import 'package:burger_app_full/pages/auth/login_screen.dart';
import 'package:burger_app_full/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
                SizedBox(
                  width: double.maxFinite,
                  child: MyButton(
                    onPressed: () async {
                      final supbase = Supabase.instance.client;
                      final AuthResponse res = await supbase.auth.signUp(
                        email: emailcontroller.text,
                        password: passwordcontroller.text,
                      );
                      if (res.user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Signup successful!')),
                        );
                      }
                    },

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
