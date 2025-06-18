import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:madadgaar/main.dart';
import 'package:madadgaar/splashscreen.dart';
import 'package:madadgaar/utils/api_controller.dart';
import 'package:madadgaar/login/signup/signup.dart';
import 'package:madadgaar/utils/image_downloader.dart';
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

  final TextEditingController _email = TextEditingController(),
      _password = TextEditingController();

  bool isEnabled = false;

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
      if (response.statusCode == 201) {
        debugPrint('Logged-in successfully: \\${response.body}');
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String? accessToken =
            responseData['access_token'] ?? responseData['token'];
        if (accessToken != null) {
          final String? firstName = responseData['user']?['firstName'] ?? '';
          final String? lastName = responseData['user']?['lastName'] ?? '';
          final String userName = (('$firstName $lastName').trim().isEmpty)
              ? 'User'
              : '$firstName $lastName';
          final String? userEmail = responseData['user']?['email'];
          final String? userPhone = responseData['user']?['phone'];
          final String? userDob = responseData['user']?['dateOfBirth'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', accessToken);
          // await prefs.setString('userName', userName);
          await prefs.setString('userFirstName', firstName ?? 'N/A');
          await prefs.setString('userLastName', lastName ?? 'N/A');
          await prefs.setString('userEmail', userEmail ?? 'N/A');
          await prefs.setString('userPhone', userPhone ?? '');
          await prefs.setString('userDob', userDob ?? '');

          // --- Profile Image Download Logic ---
          final String? profileImageUrl =
              responseData['user']?['profilePicture'];
          if (profileImageUrl != null && profileImageUrl.startsWith('http')) {
            const String fileName = 'profile_image.jpg';
            final String? localPath =
                await downloadAndSaveImage(profileImageUrl, fileName);
            if (localPath != null) {
              await prefs.setString('profileImagePath', localPath);
              debugPrint('Profile image saved locally at: $localPath');
            } else {
              debugPrint('Failed to download profile image.');
            }
          } else {
            debugPrint('No profile image URL found in response.');
          }
          // --- End Profile Image Download Logic ---

          debugPrint('User data saved: $userName, $userEmail');
          debugPrint('Access token saved to shared preferences.');
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SplashScreen(
                    home: MyApp.home), // Replace with your Home screen
              ),
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
              "Error: \\${response.statusCode} - \\${response.reasonPhrase}";
        });
        debugPrint('Failed to send Credential value: \\${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending Credential value: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _email.addListener(() {
      setState(() {
        isEnabled = _email.text.isNotEmpty && _password.text.isNotEmpty;
      });
    });
    _password.addListener(() {
      setState(() {
        isEnabled = _email.text.isNotEmpty && _password.text.isNotEmpty;
      });
    });
    super.initState();
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
                              onChanged: (_) {
                                if (_errormessage != null &&
                                    _errormessage!.isNotEmpty) {
                                  setState(() {
                                    _errormessage = null;
                                  });
                                }
                              },
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
                              onChanged: (_) {
                                if (_errormessage != null &&
                                    _errormessage!.isNotEmpty) {
                                  setState(() {
                                    _errormessage = null;
                                  });
                                }
                              },
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
                          : _email.text == '' || _password.text == ''
                              ? null
                              : () {
                                  handleLogin(_email.text, _password.text);
                                },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
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

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
