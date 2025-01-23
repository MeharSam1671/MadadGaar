import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madadgaar/Home/home.dart';
import 'package:madadgaar/login/signup/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Alignment beginAlignment;
  late Alignment endAlignment;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    beginAlignment = Alignment.topRight;
    endAlignment = Alignment.bottomRight;
    _startAnimation();
  }

  void _startAnimation() {
    // Toggle gradient direction every 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          // Toggle between two different gradients
          beginAlignment = beginAlignment == Alignment.topRight
              ? Alignment.bottomLeft
              : Alignment.topRight;
          endAlignment = endAlignment == Alignment.bottomRight
              ? Alignment.topLeft
              : Alignment.bottomRight;
        });
        _startAnimation(); // Repeat the animation
      }
    });
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? userName, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Colors.red, Colors.blue],
            begin: beginAlignment,
            end: endAlignment,
          ),
        ),
        duration: const Duration(seconds: 2),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.9),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ], // Rounded corners for the container
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text("Login",
                      style: TextStyle(fontSize: 24, color: Colors.black)),
                  const SizedBox(height: 20),
                  // Username TextField
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter username",
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded borders
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.1),
                      // Light background color for input
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20), // Space between input fields
                  // Password TextField
                  TextField(
                    controller: _passwordController,
                    obscureText: true, // To hide the password input
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded borders
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.black
                          .withOpacity(0.1), // Light background color for input
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 30), // Space before the login button
                  // Login Button
                  ElevatedButton(
                    onPressed: () async {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Email and Password cannot be empty!")),
                        );
                        return;
                      }

                      try {
                        // Sign in with Firebase Authentication
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: email, password: password);

                        // Fetch user details from Firestore
                        DocumentSnapshot userDoc = await FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(userCredential.user!.uid)
                            .get();

                        if (userDoc.exists) {
                          // Navigate to the next screen (e.g., Dashboard)
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "User does not exist in Firestore!")),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Login failed: ${e.toString()}")),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Login with Google Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Button color
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 50), // Consistent padding
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/google.png",
                          height: 25,
                          width: 25, // Ensure proper aspect ratio
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),
                        const Text("Login with Google",
                            style:
                                TextStyle(fontSize: 10, color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text("Not Signup?/Signup from here"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
