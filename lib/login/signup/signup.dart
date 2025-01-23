import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  bool isSuccessful = false;
  String error = "";

  String password = "";
  String confirmPassword = "";
  bool passwordsMatch = true;
  String user = "";
  bool checkuser = true;
  bool pass = true;
  final TextEditingController _emailController = TextEditingController();
  bool isValidEmail = true;
  String email = "";
  String fName = "";
  String lName = "";
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

  Future<void> signUp(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      var dbInstance = FirebaseFirestore.instance;
      await dbInstance.collection('users').add({
        "email": email,
        "userID": user,
        "fName": fName,
        "lName": lName,
        "password": password,
      });
      if (mounted) {
        setState(() {
          isLoading = false;
          isSuccessful = true;
        });
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          Navigator.pushNamed(context, '/LoginProfile');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (mounted) {
        setState(() {
          isLoading = false;
          error = e.toString();
          isSuccessful = false;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Colors.red, Colors.blue],
            begin: beginAlignment,
            end: endAlignment,
          ),
        ),
        duration: const Duration(seconds: 2),
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
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Signup",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    // Username Field
                    TextField(
                        decoration: InputDecoration(
                          hintText: "Enter firstname",
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.1),
                        ),
                        style: const TextStyle(color: Colors.black),
                        onChanged: (value) => {fName = value}),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter lastname",
                        hintStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) => {lName = value},
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter username",
                        hintStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
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
                          user = value;
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                    ),
                    if (!checkuser && user.isNotEmpty)
                      const Text(
                        "Username must be combination of alphabets and digits",
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    // Email Field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter email",
                        hintStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                        errorText: isValidEmail ? null : 'Invalid email format',
                      ),
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                          isValidEmail = emailRegex.hasMatch(email);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter password",
                        hintStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
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
                    const SizedBox(height: 20),
                    // Confirm Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter password again",
                        hintStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
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
                    const SizedBox(height: 20),
                    if (!passwordsMatch && confirmPassword.isNotEmpty)
                      const Text(
                        "Passwords do not match",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    const SizedBox(height: 10),
                    // Signup Button
                    ElevatedButton(
                      onPressed:
                          isLoading ? null : () async => await signUp(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const Row(
                              children: [
                                CircularProgressIndicator.adaptive(),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Saving details...",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              isSuccessful ? "Saved" : "Signup",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      error.isNotEmpty ? 'Something went wrong...' : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    // Sign-in Link
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Already have an account? Login"),
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
