import 'dart:io';
import 'package:flutter/material.dart';
import 'package:madadgaar/ChatAi/chataiscreen.dart';
import 'package:madadgaar/Home/history.dart';
import 'package:madadgaar/Home/showdialog.dart';
import 'package:madadgaar/Profile/newprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class Newhome extends StatefulWidget {
  const Newhome({super.key});

  @override
  State<Newhome> createState() => _NewhomeState();
}

class _NewhomeState extends State<Newhome> {
  // ImageProvider _profileImage = const AssetImage("assets/my_image.jpg");
  // bool _isLoggedIn = true; // Simulated login state

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final imagePath = sharedPreferences.getString('profileImagePath') ??
        sharedPreferences.getString('profileImage');
    if (imagePath != null && imagePath.isNotEmpty && mounted) {
      setState(() {
        if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
          profileImageNotifier.value = FileImage(File(imagePath));
        } else {
          profileImageNotifier.value = const AssetImage('assets/my_image.jpg');
        }
      });
    } else if (mounted) {
      setState(() {
        profileImageNotifier.value = const AssetImage('assets/my_image.jpg');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool login = true;

    final args = ModalRoute.of(context)?.settings.arguments;

    String city = 'Unknown City';
    String country = 'Unknown Country';

    if (args != null && args is Map<String, dynamic>) {
      city = args['City'] ?? 'Unknown City';
      country = args['Country'] ?? 'Unknown Country';
    } else {
      debugPrint('Route arguments are null or invalid');
    }

    final List<String> queries = [
      "I had an \naccident",
      "I need \nmedical help",
      "I feel \nunsafe",
    ];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_sharp,
                          color: theme.iconTheme.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$city, $country",
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge!.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewProfile(),
                        ),
                      );
                    },
                    child: SafeArea(
                        child: ValueListenableBuilder(
                      valueListenable: profileImageNotifier,
                      builder: (context, image, _) {
                        if (image is AssetImage) {
                          // Only avatar icon, no background image
                          return const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 20),
                          );
                        } else {
                          // Show user image
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                image: image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    )),
                  ),
                ],
              ),
            ),

            // Emergency Help Text + Button
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              left: MediaQuery.of(context).size.width / 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Need\nEmergency Help",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: theme.textTheme.headlineMedium!.color,
                      letterSpacing: 1.2,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Click the button for ambulance",
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium!.color,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Outer silver ring
                  Container(
                    padding: const EdgeInsets.all(6), // Ring thickness
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDark
                            ? [Colors.grey[900]!, Colors.grey[800]!]
                            : const [Color(0xFFF4F6F8), Color(0xFFB1BAC8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black54
                              : Colors.grey.withAlpha(153),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    // Inner red button
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Colors.white,
                            Color(0xFFD32F2F),
                            Color(0xFFD32F2F),
                            Color(0xFFD32F2F),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.redAccent.withAlpha(77)
                                : Colors.redAccent.withAlpha(128),
                            blurRadius: 30,
                            spreadRadius: 6,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.sos,
                            size: 50, color: Colors.white),
                        onPressed: () {
                          showScaleDialog(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // "Not Sure What to do?" Text
            Positioned(
              top: 460,
              left: MediaQuery.of(context).size.width / 5,
              child: Text(
                "Not Sure What to do?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: theme.textTheme.headlineMedium!.color,
                  letterSpacing: 1.2,
                  height: 1.3,
                ),
              ),
            ),

            // "Pick a Subject to call" Text
            Positioned(
              top: 490,
              left: MediaQuery.of(context).size.width / 3,
              child: Text(
                "Pick a Subject to call",
                style: TextStyle(
                  color: theme.textTheme.bodyMedium!.color,
                ),
              ),
            ),

            // Emergency Query Cards
            Positioned(
              bottom: 60,
              left: -70,
              right: 0,
              child: SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.55),
                  itemCount: queries.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          color: theme.cardColor,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  queries[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textTheme.bodyLarge!.color,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.arrow_forward,
                                        color: theme.colorScheme.error),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.text_fields,
                                      color: theme.iconTheme.color!
                                          .withAlpha(128),
                                    ),
                                    const SizedBox(width: 2),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatbotScreen(query: queries[index]),
                          ),
                        );
                      }, // <-- here closing the GestureDetector
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: theme.colorScheme.error,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HistoryPage()));
          }
          // You can add more navigation logic here
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
