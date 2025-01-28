import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String? userName;

  const ProfileScreen({super.key, this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? fName, lName, email, userID;

  @override
  @override
  void initState() {
    super.initState();
    checkuser(); // Fetch user data when the screen is initialized
  }

  Future<void> checkuser() async {
    var dbInstance = FirebaseFirestore.instance;

    // Use the passed userName from the constructor
    var querySnapshot = await dbInstance
        .collection('users')
        .where("fName",
            isEqualTo:
                widget.userName) // Access the userName using widget.userName
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        fName = querySnapshot.docs.first["fName"];
        lName = querySnapshot.docs.first["lName"];
        userID = querySnapshot.docs.first["userID"];
        email = querySnapshot.docs.first["email"];
      });
    } else {
      print("User not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          fName != null && lName != null && email != null
              ? Column(
                  children: [
                    Text(fName!),
                    Text(lName!),
                    Text(email!),
                  ],
                )
              : const Center(
                  child:
                      CircularProgressIndicator()), // Show loading indicator until data is fetched
        ],
      ),
    );
  }
}
