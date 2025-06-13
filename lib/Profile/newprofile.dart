import 'dart:io';
import 'package:flutter/material.dart';
import 'package:madadgaar/Profile/profile.dart';
import 'package:madadgaar/login/signup/login.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'aboutus.dart';
import 'appversion.dart';
import 'changepassword.dart';
import 'editprofile.dart'; // Make sure EditProfile accepts onImageChanged callback
import 'package:madadgaar/globals.dart'; // bring in the notifier

class NewProfile extends StatefulWidget {
  const NewProfile({super.key});

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  void updateUserImage(String imagePath) {
    profileImageNotifier.value = FileImage(File(imagePath));
  }

  bool _showCameraButton = false;
  String Mode="Dark Mode";
  bool _isLoggedIn = true; // Simulated login state
  ImageProvider _profileImage = const AssetImage("assets/my_image.jpg");

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
                    ? () =>
                        setState(() => _showCameraButton = !_showCameraButton)
                    : null,
                child: ValueListenableBuilder(
                  valueListenable: profileImageNotifier,
                  builder: (context, image, _) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: _isLoggedIn ? image : null,
                      child: !_isLoggedIn
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    );
                  },
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
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                  buildCardTile(context, "Edit Profile", Icons.edit, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(
                          onImageChanged: (String newImagePath) {
                            updateUserImage(
                                newImagePath); // ✅ This is the correct global update
                            setState(() {
                              _showCameraButton = true;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                  buildCardTile(context, "Change Password", Icons.password, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword()));
                  }),
                ],
                buildCardTile(context, "About Us", Icons.info, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUs()));
                }),
                buildCardTile(context, "App Version", Icons.perm_device_info,
                    () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AppVersion()));
                }),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: Text(Mode),
                    trailing: Switch(
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(value);

                        setState(() {
                          if (value == true) {
                            Mode = "Light Mode";
                          }else{
                            Mode="Dark Mode";
                          }
                        });
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
                      style: TextStyle(
                          color: _isLoggedIn ? Colors.red : Colors.green),
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
                              builder: (context) => LoginScreen()),
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
