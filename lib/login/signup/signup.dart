import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Home/Home.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String password = "";
  String confirmPassword = "";
  bool passwordsMatch = true;
  String user = "";
  bool checkuser = true;
  bool pass = true;
  final TextEditingController _emailController = TextEditingController();
  bool isValidEmail = true;
  String email = "";
  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  final RegExp useregex = RegExp(r"^[a-zA-Z]+[0-9]+$");

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.blue],
            begin: beginAlignment,
            end: endAlignment,
          ),
        ),
        duration: Duration(seconds: 2),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Container(
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
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Signup",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    // Username Field
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter firstname",
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter lastname",
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter username",
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Validate the username with the regex
                          if (useregex.hasMatch(value)) {
                            checkuser = true;
                          } else {
                            checkuser = false;
                          }
                        });
                      },
                      style: TextStyle(color: Colors.black),
                    ),
                    if (!checkuser)
                      Text(
                        "Username contains alphabets and numbers only",
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 20),
                    // Email Field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter email",
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                        errorText: isValidEmail ? null : 'Invalid email format',
                      ),
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                          isValidEmail = emailRegex.hasMatch(email);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    // Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter password",
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                      ),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                          passwordsMatch = confirmPassword == password;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    // Confirm Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter password again",
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                      ),
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
                          passwordsMatch = confirmPassword == password;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    if (!passwordsMatch && confirmPassword.isNotEmpty)
                      Text(
                        "Passwords do not match",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    SizedBox(height: 10),
                    // Signup Button
                    ElevatedButton(
                      onPressed: () {
                        // Check conditions before navigating
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => Home()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Sign-in Link
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text("Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
