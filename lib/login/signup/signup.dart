import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  Future<void> SignupApiCall(String FirstNM, String LastNM, String Email, String Password) async {
    try {
      final url = Uri.parse("https://madadgaar.centralindia.cloudapp.azure.com/api/auth/register");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'}, // ✅ JSON header
        body: jsonEncode({ // ✅ JSON body
          "firstName": FirstNM,
          "lastName": LastNM,
          "email": Email,
          "password": Password,
          "userId": "" // If required, otherwise you can remove it
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Credential Value sent successfully: ${response.body}');
      } else {
        debugPrint('Failed to send Credential value: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending Credential value: $e');
    }
  }
  TextEditingController _FirstName = TextEditingController(),
      _LastName = TextEditingController(),
      _Email = TextEditingController(),
      _Password = TextEditingController(),
      _CheckPassword = TextEditingController();

  bool buttonenabled = false;

  bool isValidEmail(String email) {
    final emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _checkFormValid() {
    setState(() {
      buttonenabled =
          _FirstName.text.isNotEmpty &&
              _LastName.text.isNotEmpty &&
              _Email.text.isNotEmpty &&
              isValidEmail(_Email.text) &&
              _Password.text.isNotEmpty &&
              _CheckPassword.text.isNotEmpty &&
              _Password.text == _CheckPassword.text;
    });
  }

  @override
  void dispose() {
    _FirstName.dispose();
    _LastName.dispose();
    _Email.dispose();
    _Password.dispose();
    _CheckPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(

          color: Theme.of(context).scaffoldBackgroundColor,

        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          controller: _FirstName,
                          onChanged: (_) => _checkFormValid(),
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(Icons.person, color: Colors.black),
                          ),
                        ),
                        const Divider(color: Colors.black),
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          controller: _LastName,
                          onChanged: (_) => _checkFormValid(),
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(Icons.person, color: Colors.black),
                          ),
                        ),
                        const Divider(color: Colors.black),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.black),
                              controller: _Email,
                              onChanged: (_) => _checkFormValid(),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                icon: Icon(Icons.email, color: Colors.black),
                              ),
                            ),
                            if (_Email.text.isNotEmpty &&
                                !isValidEmail(_Email.text))
                              const Padding(
                                padding: EdgeInsets.only(left: 40, top: 4),
                                child: Row(
                                  children: [
                                    Text("Alert",style: TextStyle(color: Colors.redAccent),),
                                    Text(
                                      'Invalid email format',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const Divider(color: Colors.black),
                        TextField(
                          obscureText: true,
                          controller: _Password,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (_) => _checkFormValid(),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(Icons.lock, color: Colors.black),
                          ),
                        ),
                        const Divider(color: Colors.black),
                        TextField(
                          obscureText: true,
                          controller: _CheckPassword,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (_) => _checkFormValid(),
                          decoration: InputDecoration(
                            hintText: 'Enter Password again',
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(Icons.lock, color: Colors.black),
                          ),
                        ),
                        if (_Password.text != _CheckPassword.text &&
                            _CheckPassword.text.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.only(left: 40, top: 4),
                            child: Row(
                              children: [
                                Text("Alert:",style: TextStyle(color: Colors.redAccent),),
                                Text(
                                  'Passwords do not match',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: buttonenabled
                      ? () {
                    SignupApiCall(_FirstName.text,_LastName.text,_Email.text,_Password.text);

                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: const Color(0xFF8E2DE2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                /*const Text(
                  "or",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Google sign-up logic
                  },
                  icon: Image.asset(
                    'assets/google.png',
                    height: 24,
                    width: 24,
                  ),
                  label: const Text(
                    'Sign up with Google',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
