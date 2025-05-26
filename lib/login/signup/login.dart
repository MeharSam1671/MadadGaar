import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _errormessage;
  bool _isLoading = false; // 1. Add this

  Future<void> CheckUserCredentail(String Email, String Password) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final url = Uri.parse('http://10.0.2.2:4000/api/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "email": Email,
          "password": Password,
        },
      );

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
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('userName', userName ?? 'User');
          debugPrint('Access token saved to shared preferences.');
          Navigator.pushReplacementNamed(
            context,
            '/Home',
          ); // Navigate to Home screen
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

  TextEditingController _Email = TextEditingController(),
      _Password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade500,
              Colors.purple.shade300
            ], // Gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.white.withOpacity(0.1),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        TextField(
                          controller: _Email,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            icon: Icon(Icons.email, color: Colors.white),
                          ),
                        ),
                        Divider(color: Colors.white38),
                        TextField(
                          controller: _Password,
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            icon: Icon(Icons.lock, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_errormessage != null && _errormessage!.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errormessage!,
                      style: TextStyle(color: Colors.redAccent, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null // 4. Disable button if loading
                      : () {
                          CheckUserCredentail(_Email.text, _Password.text);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF8E2DE2),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFF8E2DE2),
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                SizedBox(height: 20),
                Text(
                  "or",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/google.png',
                    height: 24,
                    width: 24,
                  ),
                  label: Text(
                    'Sign up with Google',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
