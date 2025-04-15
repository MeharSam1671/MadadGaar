import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madadgaar/login/signup/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Alignment beginAlignment;
  late Alignment endAlignment;
  bool _showPassword = false; // Add this state variable for password visibility

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
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          beginAlignment = beginAlignment == Alignment.topRight
              ? Alignment.bottomLeft
              : Alignment.topRight;
          endAlignment = endAlignment == Alignment.bottomRight
              ? Alignment.topLeft
              : Alignment.bottomRight;
        });
        _startAnimation();
      }
    });
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? userName, password;
  bool Login = false;
  bool isLoading = false;
  Future<void> checkuser() async {
    setState(() {
      isLoading = true;
    });
    var dbInstance = FirebaseFirestore.instance;
    var querySnapshot = await dbInstance
        .collection('users')
        .where("userID", isEqualTo: userName)
        .where("password", isEqualTo: password)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Login = true;
      await prefs.setString("userName", querySnapshot.docs.first["fName"]);

      userName = querySnapshot.docs.first["fName"];
    } else {
      print("not found");
    }
    setState(() {
      isLoading = false;
    });
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
                TextField(
                  controller: _emailController,
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
                      userName = value;
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 20),
                // Updated Password TextField with visibility toggle
                TextField(
                  controller: _passwordController,
                  obscureText:
                      !_showPassword, // Toggle based on _showPassword state
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    // Add suffix icon for password visibility toggle
                    suffixIcon: password?.isNotEmpty ?? false
                        ? IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: !isLoading &&
                          (userName?.isNotEmpty ?? false) &&
                          (password?.isNotEmpty ?? false)
                      ? () async {
                          await checkuser();
                          if (Login) {
                            Navigator.pushNamed(context, "/Home",
                                arguments: userName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Invalid username or password")),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: isLoading
                      ? const Row(
                          children: [
                            Icon(Icons.timelapse),
                            Text(
                              "Logging you in...",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/google.png",
                        height: 25,
                        width: 25,
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
