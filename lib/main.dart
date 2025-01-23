import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:madadgaar/ChatAi/chataiscreen.dart';
import 'package:madadgaar/login/signup/signup.dart';
import 'Home/home.dart';
import 'maps.dart';
import 'Profile/profile.dart';
import 'login/signup/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
        "/maps": (context) => const Maps(),
        "/Home": (context) => const Home(),
        "/ChatAI": (context) => const ChatAIScreen(),
        "/Signup": (context) => const SignupScreen(),
        '/showProfile': (context) => const ProfileScreen(),
        '/LoginProfile': (context) => const LoginScreen(),
      },
      home: const Home(),
    );
  }
}
