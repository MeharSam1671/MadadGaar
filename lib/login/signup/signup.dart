import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:madadgaar/utils/api_controller.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool _isLoading = false;
  String? _errormessage;
  final apiController = ApiController();

  Future<void> signupApiCall(
      String firstName, String lastName, String email, String password) async {
    try {
      setState(() {
        _isLoading = true; // 1. Show loading indicator
      });
      final response = await apiController.post('/auth/register', {
        // ✅ JSON body
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
        "userId": email
      });

      if (response.statusCode == 201) {
        debugPrint('Credential Value sent successfully: ${response.body}');
      } else {
        _errormessage = jsonDecode(response.body)?['message']?.toString();
        debugPrint('Failed to send Credential value: ${response.statusCode}');
      }
    } catch (e) {
      _errormessage = e.toString();
      debugPrint('Error sending Credential value: $e');
    }
    finally {
      setState(() {
        _isLoading = false; // 2. Hide loading indicator
      });
      if (mounted && _errormessage == null) {
        Navigator.pushReplacementNamed(context, '/LoginProfile');
      }
    }
  }
  final TextEditingController _firstName = TextEditingController(),
      _lastName = TextEditingController(),
      _email = TextEditingController(),
      _password = TextEditingController(),
      _checkPassword = TextEditingController();

  bool buttonenabled = false;

  bool isValidEmail(String email) {
    final emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _checkFormValid() {
    setState(() {
      buttonenabled =
          _firstName.text.isNotEmpty &&
          _lastName.text.isNotEmpty &&
          _email.text.isNotEmpty &&
          isValidEmail(_email.text) &&
          _password.text.isNotEmpty &&
          _checkPassword.text.isNotEmpty &&
          _password.text == _checkPassword.text;
    });
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _checkPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                        color: Colors.black.withAlpha(26),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.black),
                              controller: _firstName,
                              onChanged: (_) {
                                if (_errormessage != null &&
                                    _errormessage!.isNotEmpty) {
                                  setState(() {
                                    _errormessage = null;
                                  });
                                }
                                _checkFormValid();
                              },
                              decoration: const InputDecoration(
                                hintText: 'First Name',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                icon: Icon(Icons.person, color: Colors.black),
                              ),
                            ),
                            const Divider(color: Colors.black),
                            TextField(
                              style: const TextStyle(color: Colors.black),
                              controller: _lastName,
                              onChanged: (_) {
                                if (_errormessage != null &&
                                    _errormessage!.isNotEmpty) {
                                  setState(() {
                                    _errormessage = null;
                                  });
                                }
                                _checkFormValid();
                              },
                              decoration: const InputDecoration(
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
                                  controller: _email,
                                  onChanged: (_) {
                                    if (_errormessage != null &&
                                        _errormessage!.isNotEmpty) {
                                      setState(() {
                                        _errormessage = null;
                                      });
                                    }
                                    _checkFormValid();
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                    icon:
                                        Icon(Icons.email, color: Colors.black),
                                  ),
                                ),
                                if (_email.text.isNotEmpty &&
                                    !isValidEmail(_email.text))
                                  const Padding(
                                    padding: EdgeInsets.only(left: 40, top: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Invalid email format',
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const Divider(color: Colors.black),
                            TextField(
                              obscureText: true,
                              controller: _password,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (_) {
                                if (_errormessage != null &&
                                    _errormessage!.isNotEmpty) {
                                  setState(() {
                                    _errormessage = null;
                                  });
                                }
                                _checkFormValid();
                              },
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                icon: Icon(Icons.lock, color: Colors.black),
                              ),
                            ),
                            const Divider(color: Colors.black),
                            TextField(
                              obscureText: true,
                              controller: _checkPassword,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (_) {
                                if (_errormessage != null &&
                                    _errormessage!.isNotEmpty) {
                                  setState(() {
                                    _errormessage = null;
                                  });
                                }
                                _checkFormValid();
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter Password again',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                icon: Icon(Icons.lock, color: Colors.black),
                              ),
                            ),
                            if (_password.text != _checkPassword.text &&
                                _checkPassword.text.isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.only(left: 40, top: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      'Passwords do not match',
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (_errormessage != null && _errormessage!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(61),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _errormessage!,
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: buttonenabled
                          ? () {
                              signupApiCall(_firstName.text, _lastName.text,
                                  _email.text, _password.text);
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
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(77),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
