import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:madadgaar/auth/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String? userName;

  const ProfileScreen({super.key, this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? fName, lName, email, userID;
  final AuthUtils authUtils = AuthUtils();
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
        .where("fName", isEqualTo: widget.userName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        fName = querySnapshot.docs.first["fName"];
        lName = querySnapshot.docs.first["lName"];
        userID = querySnapshot.docs.first["userID"];
        email = querySnapshot.docs.first["email"];
      });
    } else {
      if (kDebugMode) {
        print("User not found");
      }
      if (mounted) {
        await authUtils.logOut(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () async {
                if (kDebugMode) {
                  print("Logout button pressed");
                }
                await authUtils.logOut(context, silent: false);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (fName != null && lName != null && email != null)
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      '${fName![0]}${lName![0]}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$fName $lName',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  // You can add more profile information here if needed
                ],
              )
            else
              const Column(
                children: [
                  CircularProgressIndicator(), // Show loading indicator until data is fetched
                  Text("Fetching your data..."),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
