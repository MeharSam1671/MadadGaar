import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madadgaar/login/signup/signup.dart';
import 'package:madadgaar/main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.blue], // Red and Blue colors for the gradient
              begin: Alignment.bottomLeft, // Starting point of the gradient
              end: Alignment.topRight, // Ending point of the gradient
              stops: [0.1, 1.0], // Control how the colors blend

            ),
          ),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width / 1.2,

              decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(40), // Rounded corners for the container
              ),
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Login",style: TextStyle(fontSize: 24,color: Colors.black),),
                  SizedBox(height: 40,),
                  // Username TextField
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter username",
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded borders
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.1), // Light background color for input
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20), // Space between input fields
                  // Password TextField
                  TextField(
                    obscureText: true, // To hide the password input
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded borders
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.1), // Light background color for input
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 30), // Space before the login button
                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle login logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded button
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(onPressed: (){}, child:
                      Container(
                          decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10),),

                          child: ListTile(title: Text("Login with Google",style: TextStyle(fontSize: 12,color: Colors.white),),leading: Image.asset("assets/google.png",height: 25,),)),

                      //Image.asset("assets/google.png"),


                    ),

                  // Sign-up link
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => SignupScreen()));
                  }, child: Text("Don't have an account? Signup"))
                ],
              ),
            ),
          ),
        ),
    );
  }
}
