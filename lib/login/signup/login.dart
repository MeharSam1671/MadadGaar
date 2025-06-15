import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:madadgaar/utils/api_controller.dart';
import 'package:madadgaar/login/signup/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _errormessage;
  bool _isLoading = false; // 1. Add this

  final apiController = ApiController();

  Future<void> handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await apiController.post(
        "/auth/login",
        {
          "email": email,
          "password": password,
        },
      );
      // final response = await http.post(
      //   url,
      //   headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      //   body: {
      //     "email": Email,
      //     "password": Password,
      //   },
      // );

      if (response.statusCode == 201) {
        debugPrint('Logged-in successfully: ${response.body}');
        // Parse the response and save access token
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String? accessToken =
            responseData['access_token'] ?? responseData['token'];
        if (accessToken != null) {
          // Save token in shared preferences

          final String? userName = responseData['user']?['firstName'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', accessToken);
          await prefs.setString('userName', userName ?? 'User');
          debugPrint('Access token saved to shared preferences.');
          if (mounted) {
            Navigator.pushReplacementNamed(
              context,
              '/Home',
            ); // Navigate to Home screen
          }
        } else {
          debugPrint('No access token found in response.');
        }
        setState(() {
          _errormessage = null;
        });
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 404) {
        setState(() {
          _errormessage = "Wrong Email or Password";
        });
      } else {
        setState(() {
          _errormessage =
              "Error: ${response.statusCode} - ${response.reasonPhrase}";
        });
        debugPrint('Failed to send Credential value: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending Credential value: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final TextEditingController _email = TextEditingController(),
      _password = TextEditingController();

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
                  "Welcome Back",
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
                          controller: _email,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(Icons.email, color: Colors.black),
                          ),
                        ),
                        const Divider(color: Colors.black),
                        TextField(
                          controller: _password,
                          style: const TextStyle(color: Colors.black),
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            icon: Icon(Icons.lock, color: Colors.black),
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
                  onPressed: _isLoading
                      ? null // 4. Disable button if loading
                      : () {
                          handleLogin(_email.text, _password.text);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFF8E2DE2),
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ));
                    },
                    child: const Text("Don't have account"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
