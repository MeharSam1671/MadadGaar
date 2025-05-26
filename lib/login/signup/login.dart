import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _errormessage;
  Future<void> CheckUserCredentail(String Email, String Password) async {
    try {
      final url = Uri.parse('https://madadgaar.centralindia.cloudapp.azure.com/api/auth/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "email": Email,
          "password": Password,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Credential Value sent successfully: ${response.body}');
        setState(() {
          _errormessage = null;
        });
      } else if (response.statusCode == 400) {
        setState(() {
          _errormessage = "Wrong Email and Password";
        });
      } else {
        setState(() {
          _errormessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
        });
        debugPrint('Failed to send Credential value: ${response.statusCode}');
      }

    } catch (e) {
      debugPrint('Error sending Credential value: $e');

    }

  }

  TextEditingController _Email=TextEditingController(),_Password=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.purple.shade300], // Gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding:  EdgeInsets.symmetric(horizontal: 30),
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
                    padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        TextField(
                          controller: _Email,
                          style:  TextStyle(color: Colors.white),
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
                          style:  TextStyle(color: Colors.white),
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
                  onPressed: () {
                    CheckUserCredentail(_Email.text, _Password.text);

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor:  Color(0xFF8E2DE2),
                    padding:  EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:  Text(
                    'Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                 SizedBox(height: 20),

                 Text(
                  "or",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),

                 SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: Image.asset(
                    'assets/google.png',
                    height: 24,
                    width: 24,
                  ),
                  label:  Text(
                    'Sign up with Google',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
