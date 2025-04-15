import 'dart:async';

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
  Timer? idInputInactiveRecorder, emailInputInactiveRecorder;

  bool _showPassword = false;
  bool _showCnfrmPassword = false;

  bool isLoading = false;
  bool isSuccessful = false;
  String error = "";

  bool isUniqueUserID = true;
  bool isIDCheckInProgress = false;
  bool isUniqueEmail = true;
  bool isEmailCheckInProgress = false;

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

  @override
  void dispose() {
    idInputInactiveRecorder?.cancel();
    emailInputInactiveRecorder?.cancel();
    super.dispose();
  }

  Future<void> signUp(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      var dbInstance = FirebaseFirestore.instance;

      // Add the createdAt field with the current timestamp
      await dbInstance.collection('users').add({
        "email": email,
        "userID": user,
        "fName": fName,
        "lName": lName,
        "password": password,
        "createdAt": FieldValue.serverTimestamp(), // Adding createdAt field
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

  Future<void> isIDUnique() async {
    try {
      if (idInputInactiveRecorder?.isActive ?? false) {
        idInputInactiveRecorder?.cancel();
      }
      idInputInactiveRecorder =
          Timer(const Duration(milliseconds: 500), () async {
        setState(() {
          isIDCheckInProgress = true;
        });
        var dbInstance = FirebaseFirestore.instance;
        var existingUser = await dbInstance
            .collection('users')
            .where('userID', isEqualTo: user)
            .get();
        if (existingUser.docs.isEmpty) {
          setState(() {
            isUniqueUserID = true;
          });
        } else {
          setState(() {
            isUniqueUserID = false;
          });
        }
        setState(() {
          isIDCheckInProgress = false;
        });
      });
    } catch (e) {
      setState(() {
        isUniqueUserID = false;
        isIDCheckInProgress = false;
      });
    }
  }

  Future<void> isEmailUnique() async {
    try {
      if (emailInputInactiveRecorder?.isActive ?? false) {
        emailInputInactiveRecorder?.cancel();
      }
      emailInputInactiveRecorder =
          Timer(const Duration(milliseconds: 500), () async {
        setState(() {
          isEmailCheckInProgress = true;
        });
        var dbInstance = FirebaseFirestore.instance;
        var existingUser = await dbInstance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        if (existingUser.docs.isEmpty) {
          setState(() {
            isUniqueEmail = true;
          });
        } else {
          setState(() {
            isUniqueEmail = false;
          });
        }
        setState(() {
          isEmailCheckInProgress = false;
        });
      });
    } catch (e) {
      setState(() {
        isUniqueEmail = false;
        isEmailCheckInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
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
                    suffixIcon: user.isNotEmpty
                        ? isIDCheckInProgress
                            ? const Icon(Icons.timelapse)
                            : Icon(
                                isUniqueUserID && checkuser
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: isUniqueUserID && checkuser
                                    ? Colors.green
                                    : Colors.red,
                              )
                        : null,
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
                    // Validate the username with the regex
                    if (useregex.hasMatch(value)) {
                      setState(() {
                        checkuser = true;
                      });
                      isIDUnique();
                    } else {
                      setState(() {
                        checkuser = false;
                      });
                    }
                    user = value;
                  },
                  style: const TextStyle(color: Colors.black),
                ),
                if (user.isNotEmpty && !(checkuser && isUniqueUserID))
                  Text(
                    !checkuser
                        ? "Username must be combination of alphabtes and digits"
                        : "This user ID is already in use",
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    suffixIcon: email.isNotEmpty
                        ? isEmailCheckInProgress
                            ? const Icon(Icons.timelapse)
                            : Icon(
                                isUniqueEmail && isValidEmail
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: isUniqueEmail && isValidEmail
                                    ? Colors.green
                                    : Colors.red,
                              )
                        : null,
                    hintText: "Enter email",
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    errorText: !isValidEmail
                        ? 'Invalid email format'
                        : email.isNotEmpty && !isUniqueEmail
                            ? 'This email is already in use'
                            : null,
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                      isValidEmail =
                          emailRegex.hasMatch(email) || email.isEmpty;
                    });
                    if (isValidEmail) {
                      isEmailUnique();
                    }
                  },
                ),
                const SizedBox(height: 20),
                // Password Field
                TextField(
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    suffixIcon: password.isNotEmpty
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
                  obscureText: !_showCnfrmPassword,
                  decoration: InputDecoration(
                    suffixIcon: confirmPassword.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              _showCnfrmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                _showCnfrmPassword = !_showCnfrmPassword;
                              });
                            },
                          )
                        : null,
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
                  onPressed: !(isUniqueEmail &&
                              isUniqueUserID &&
                              fName.isNotEmpty &&
                              lName.isNotEmpty &&
                              password.isNotEmpty &&
                              passwordsMatch) ||
                          isLoading
                      ? null
                      : () async => await signUp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const Row(
                          children: [
                            Icon(Icons.timelapse),
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
    );
  }
}
