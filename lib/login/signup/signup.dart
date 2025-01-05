import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Home/Home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String password = "";
  String confirmPassword = "";
  bool passwordsMatch = true;
  String user="";
  bool checkuser=true;
  bool pass=true;
  final TextEditingController _emailController = TextEditingController();
  bool isValidEmail = true; // To track whether the email is valid
  String email = ""; // To store the email text
  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", // Regular expression for email validation
  );
  final RegExp useregex = RegExp(r"^[a-zA-Z]+[0-9]+$");


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.blue], // Red and Blue gradient
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.1, 1.0],
            ),
          ),
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
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Adapts to content height
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
                              checkuser = true; // Username is valid
                            } else {
                              checkuser = false; // Username is invalid
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
                          errorText: isValidEmail ? null : 'Invalid email format', // Show error text if invalid
                        ),
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                            // Validate email format using regex
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
                      SizedBox(height: 30),

                      // Signup Button
                      ElevatedButton(
                        onPressed: () {
                          // Check the conditions before navigating
                          //if (checkuser && passwordsMatch && isValidEmail) {
                            Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => Home()));

                          //} else {
                            // Optionally, show a message if validation fails
                            //print("Please fill in all the fields correctly");
                          //}
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Signup",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      // Login with Google Button
                      TextButton(onPressed: (){}, child:
                      Container(
                          decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10),),

                          child: ListTile(title: Text("Signup with Google",style: TextStyle(fontSize: 12,color: Colors.white),),leading: Image.asset("assets/google.png",height: 25,),)),

                        //Image.asset("assets/google.png"),


                      ),
                      SizedBox(height: 20),
                      // Sign-in Link
                      TextButton(
                        onPressed: () {
                          // Navigate to login page
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
