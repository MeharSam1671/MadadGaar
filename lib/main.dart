import 'package:flutter/material.dart';
import 'Home.dart'; // Ensure this file exists
import 'Maps.dart';
import 'Profile.dart'; // Ensure this file exists

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0; // Track the selected index
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/maps": (context) => Maps(), // Corrected the syntax for route definition
      },
      home: Scaffold(
        appBar: AppBar(
          title: _currentIndex == 0 // Change title based on current index
              ? ListTile(
            contentPadding: EdgeInsets.all(0), // Remove default padding
            leading: Text(
              "Home",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )
              : Text("Profile"),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Add search functionality if needed
              },
            ),
          ],
        ),
        body: _currentIndex == 0 ? Home() : Profile(), // Render Home or Profile
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account",
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index; // Update the selected index
            });
          },
        ),
      ),
    );
  }
}