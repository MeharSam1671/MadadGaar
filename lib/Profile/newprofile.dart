import 'dart:io';
import 'package:flutter/material.dart';
import 'package:madadgaar/login/signup/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  String name = "Hafiz Abdul Samad";
  String email = "samadali1671@gmail.com";

  bool _showCameraButton = false;
  String mode = "Dark Mode";
  bool _isLoggedIn = true; // Simulated login state
  // ImageProvider _profileImage = const AssetImage("assets/my_image.jpg");

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('auth_token');
    final userFirstName = sharedPreferences.getString('userFirstName');
    final userLastName = sharedPreferences.getString('userLastName');
    final userName = '${userFirstName ?? ''} ${userLastName ?? ''}'.trim();
    final userEmail = sharedPreferences.getString('userEmail');
    // Try both possible keys for image path
    final imagePath = sharedPreferences.getString('profileImagePath') ??
        sharedPreferences.getString('profileImage');
    if (token != null && userName.isNotEmpty) {
      setState(() {
        _isLoggedIn = true;
        name = userName;
        email = userEmail ?? 'N/A';
        if (imagePath != null &&
            imagePath.isNotEmpty &&
            File(imagePath).existsSync()) {
          profileImageNotifier.value = FileImage(File(imagePath));
        } else {
          profileImageNotifier.value = const AssetImage('assets/my_image.jpg');
        }
      });
    } else {
      setState(() {
        _isLoggedIn = false;
        profileImageNotifier.value = const AssetImage('assets/my_image.jpg');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    if (image is AssetImage) {
                      // Only avatar icon, no background image
                      return const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 50),
                      );
                    } else {
                      // Show user image
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: image,
                      );
                    }
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
                            builder: (context) => const ChangePassword()));
                  }),
                ],
                buildCardTile(context, "About Us", Icons.info, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AboutUs()));
                }),
                buildCardTile(context, "App Version", Icons.perm_device_info,
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppVersion()));
                }),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: Text(mode),
                    trailing: Switch(
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(value);

                        setState(() {
                          if (value == true) {
                            mode = "Light Mode";
                          } else {
                            mode = "Dark Mode";
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
                    onTap: () async {
                      if (_isLoggedIn) {
                        final sharedPreferences =
                            await SharedPreferences.getInstance();
                        // Remove all auth-related keys
                        await sharedPreferences.remove('auth_token');
                        await sharedPreferences.remove('userName');
                        await sharedPreferences.remove('userFirstName');
                        await sharedPreferences.remove('userLastName');
                        await sharedPreferences.remove('userEmail');
                        await sharedPreferences.remove('userPhone');
                        await sharedPreferences.remove('userDob');
                        // Remove profile image file if exists
                        final imagePath =
                            sharedPreferences.getString('profileImagePath') ??
                                sharedPreferences.getString('profileImage');
                        if (imagePath != null && imagePath.isNotEmpty) {
                          final file = File(imagePath);
                          if (file.existsSync()) {
                            try {
                              file.deleteSync();
                            } catch (e) {
                              // Ignore file deletion errors
                            }
                          }
                        }
                        await sharedPreferences.remove('profileImagePath');
                        await sharedPreferences.remove('profileImage');
                        // Reset notifier to default avatar
                        profileImageNotifier.value =
                            const AssetImage('assets/my_image.jpg');
                        setState(() => _isLoggedIn = false);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
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
