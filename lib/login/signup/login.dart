import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madadgaar/Home/Home.dart';
import 'package:madadgaar/login/signup/signup.dart';
import 'package:madadgaar/main.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

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
  void initState() {
    super.initState();
    beginAlignment = Alignment.topRight;
    endAlignment = Alignment.bottomRight;
    _startAnimation();
  }

  void _startAnimation() {
    // Toggle gradient direction every 2 seconds
    Future.delayed(Duration(seconds: 2), () {
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

  String? UserName,Password;


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
        duration: Duration(seconds: 2),
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
                  offset: Offset(0, 5),
                ),
              ], // Rounded corners for the container
            ),
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text("Login", style: TextStyle(fontSize: 24, color: Colors.black)),
                SizedBox(height: 20),
                // Username TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Enter username",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded borders
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    // Light background color for input
                  ),
                  style: TextStyle(color: Colors.black),

                ),
                SizedBox(height: 20), // Space between input fields
                // Password TextField
                TextField(
                  controller: _passwordController,
                  obscureText: true, // To hide the password input
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded borders
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1), // Light background color for input
                  ),
                  style: TextStyle(color: Colors.black),

                ),
                SizedBox(height: 30), // Space before the login button
                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Email and Password cannot be empty!")),
                      );
                      return;
                    }

                    try {
                      // Sign in with Firebase Authentication
                      UserCredential userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(email: email, password: password);

                      // Fetch user details from Firestore
                      DocumentSnapshot userDoc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userCredential.user!.uid)
                          .get();

                      if (userDoc.exists) {
                        // Navigate to the next screen (e.g., Dashboard)
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("User does not exist in Firestore!")),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Login failed: ${e.toString()}")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),

                SizedBox(height: 20),
                // Login with Google Button
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/google.png",
                        height: 25,
                        width: 25, // Ensure proper aspect ratio
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 10),
                      Text("Login with Google", style: TextStyle(fontSize: 10, color: Colors.white)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Button color
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50), // Consistent padding
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text("Not Signup?/Signup from here"),
                ),
                SizedBox(height: 20),
              ],
            ),),
          ),
        ),
      ),
    );
  }
}
