import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text("Login", style: TextStyle(fontSize: 24, color: Colors.black)),
                SizedBox(height: 20),
                // Username TextField
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter username",
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
                SizedBox(height: 20), // Space between input fields
                // Password TextField
                TextField(
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
                  onPressed: () {
                    // Handle login logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50), // Consistent padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // Rounded button
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
