import 'package:burger_app_full/pages/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  Future<String?> signUp(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return null;
      }
      return 'unknown Error occured';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error:$e';
    }
  }

  // Login Function
  Future<String?> Login_password(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return null;
      }
      return 'Inavalid username or password';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error:$e';
    }
  }

  // Sign out function
  Future<void> Logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
