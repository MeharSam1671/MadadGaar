import 'package:flutter/material.dart';
import 'package:madadgaar/login/signup/signup.dart';
import 'Home/Home.dart'; // Ensure this file exists
import 'Maps.dart';
import 'Profile.dart';
import 'Profile/profile.dart';
import 'login/signup/login.dart'; // Ensure this file exists

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0; // Track the selected index
  final TextEditingController _searchController = TextEditingController();
  Color primaryColor = Color(0xFFE0F7FA);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/maps": (context) => Maps(), // Corrected the syntax for route definition
        "/Home": (context) => Home(), // Corrected the syntax for route definition
        "/Signup": (context) => SignupScreen(),

        '/showProfile': (context) => ProfileScreen(),
        '/LoginProfile': (context) => LoginScreen(),// Corrected the syntax for route definition
      },
      home:  Home(),// Render Home or Profile
    );
  }
}
