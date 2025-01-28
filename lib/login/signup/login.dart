import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  bool Login = false;
  Future<void> checkuser() async {
    var dbInstance = FirebaseFirestore.instance;
    var querySnapshot = await dbInstance
        .collection('users')
        .where("userID", isEqualTo: userName)
        .where("password", isEqualTo: password)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      Login = true;
      userName = querySnapshot.docs.first["fName"];
    } else {
      print("not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
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
                  onChanged: (value) {
                    setState(() {
                      userName = value;
                    });
                  },
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
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 30), // Space before the login button
                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    await checkuser(); // Call checkuser() to validate credentials
                    if (Login) {
                      // Navigate to Home screen if login is successful
                      Navigator.pushNamed(context, "/Home",
                          arguments: userName);
                    } else {
                      // Show an error message if login fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Invalid username or password")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
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
                        vertical: 0, horizontal: 50), // Consistent padding
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
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
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
    );
  }
}
