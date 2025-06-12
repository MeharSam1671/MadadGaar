import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String? userName;

  const ProfileScreen({super.key, this.userName});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
// Dummy variables for this example
  String fName = 'Hafiz Abdul';
  String lName = 'Samad';
  String email = 'samadali1671@gmail.com';
  String dob = '06/04/2001';
  String userID = '1667';
  bool isEditing = false;

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();

  void saveChanges() {
    setState(() {
      fName = fNameController.text;
      lName = lNameController.text;
      email = emailController.text;
      dob = dobController.text;
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF3F9), // Transparent to show gradient

      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(


        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     // Push text to center by taking left space
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ), // Push icon to right side
                    IconButton(
                      onPressed: () async {
                        // Your logout logic here
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      tooltip: "Log Out",
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.blue.shade50],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 18),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blue.shade100,
                            backgroundImage: AssetImage("assets/my_image.jpg"),
                          ),
                          const SizedBox(height: 20),
                          isEditing
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextField(
                                      controller: fNameController,
                                      decoration: const InputDecoration(
                                          labelText: "First Name"),
                                      textAlign: TextAlign.center,
                                    ),
                                    TextField(
                                      controller: lNameController,
                                      decoration: const InputDecoration(
                                          labelText: "Last Name"),
                                      textAlign: TextAlign.center,
                                    ),
                                    TextField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                          labelText: "Email"),
                                      textAlign: TextAlign.center,
                                    ),
                                    TextField(
                                      controller: dobController,
                                      decoration: const InputDecoration(
                                          labelText: "Date of Birth"),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      onPressed: saveChanges,
                                      icon: const Icon(Icons.save),
                                      label: const Text("Save"),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$fName $lName',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.email, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          email,
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.cake, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          dob,
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Column(
                                      children: [
                                        const Text('User ID',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text(userID),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        fNameController.text = fName;
                                        lNameController.text = lName;
                                        emailController.text = email;
                                        dobController.text = dob;
                                        setState(() => isEditing = true);
                                      },
                                      icon: const Icon(Icons.edit),
                                      label: const Text("Edit"),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
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
