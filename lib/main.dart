import 'package:burger_app_full/pages/Screen/app_main_screen.dart';
import 'package:burger_app_full/pages/Screen/Profile_screen.dart';
import 'package:burger_app_full/pages/Screen/on_bordingscreen.dart';
import 'package:burger_app_full/pages/auth/login_screen.dart';
import 'package:burger_app_full/pages/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rpdnuahwiupkfhlpdlzt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwZG51YWh3aXVwa2ZobHBkbHp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMwOTMzMTksImV4cCI6MjA2ODY2OTMxOX0.W7pkXA_PBbrExiOW3AtxuuSq50Bx7rUUDgDAfrFz4Q4',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Authcheck());
  }
}

class Authcheck extends StatelessWidget {
  final supabase = Supabase.instance.client;
  Authcheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;
        if (session != null) {
          return AppMainScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
