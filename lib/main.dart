import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madadgaar/ChatAi/chataiscreen.dart';
import 'package:madadgaar/firebase_options.dart';
import 'package:madadgaar/login/signup/signup.dart';
import 'Home/home.dart'; // Ensure this file exists
import 'Maps.dart';
import 'Profile/profile.dart';
import 'login/signup/login.dart'; // Ensure this file exists

void main() async {
  // Ensure bindings are initialized before interacting with them
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation
        .portraitDown, // Optional, if you want to allow upside-down portrait
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color primaryColor = const Color(0xFFE0F7FA);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/maps": (context) =>
            const Maps(), // Corrected the syntax for route definition
        "/Home": (context) =>
            const Home(), // Corrected the syntax for route definition
        "/ChatAI": (context) =>
            const ChatAIScreen(), // Corrected the syntax for route definition
        "/Signup": (context) => const SignupScreen(),
        '/showProfile': (context) => const ProfileScreen(),
        '/LoginProfile': (context) =>
            const LoginScreen(), // Corrected the syntax for route definition
      },
      home: const Home(), // Render Home or Profile
    );
  }
}
