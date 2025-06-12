import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madadgaar/Profile/profile.dart';
import 'package:madadgaar/login/signup/login.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // Assuming ThemeProvider is defined here // Create or import your ProfileScreen

class NewProfile extends StatefulWidget {
  const NewProfile({super.key});

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  bool _showCameraButton = false;
  bool _isLoggedIn = true; // Simulated login state
  ImageProvider _profileImage = const AssetImage("assets/my_image.jpg");
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = FileImage(File(image.path));
        _showCameraButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = "Hafiz Abdul Samad";
    String email = "samadali1671@gmail.com";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _isLoggedIn
                    ? () => setState(() => _showCameraButton = !_showCameraButton)
                    : null,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _isLoggedIn ? _profileImage : null,
                      child: !_isLoggedIn
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    if (_isLoggedIn && _showCameraButton)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).cardColor,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Name
          if (_isLoggedIn)
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

          if (_isLoggedIn)
          Positioned(
            top: 240,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  email,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
          ),

          // Card Options
          Positioned(
            top: 330,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (_isLoggedIn) ...[
                  buildCardTile(context, "Edit Profile", Icons.edit, () {}),
                  buildCardTile(context, "Change Password", Icons.password, () {}),

                ],
                buildCardTile(context, "About Us", Icons.info, () {}),
                buildCardTile(context, "App Version", Icons.perm_device_info, () {}),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text("Dark Mode"),
                    trailing: Switch(
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Logout or Login Button
                Card(
                  child: ListTile(
                    title: Text(
                      _isLoggedIn ? "Logout" : "Login",
                      style: TextStyle(color: _isLoggedIn ? Colors.red : Colors.green),
                    ),
                    leading: Icon(
                      _isLoggedIn ? Icons.logout : Icons.login,
                      color: _isLoggedIn ? Colors.red : Colors.green,
                    ),
                    onTap: () {
                      if (_isLoggedIn) {
                        setState(() => _isLoggedIn = false);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                        )
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
