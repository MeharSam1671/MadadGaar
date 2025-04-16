import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madadgaar/Home/emergency_dialog.dart';
import 'package:madadgaar/Profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Blogs/blogs.dart';
import 'fulltext.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentTime = ''; // For displaying the current time
  int _currentIndex = 0; // For bottom navigation bar index
  Timer? _timer; // Timer to update the current time periodically
  late Alignment beginAlignment;
  late Alignment endAlignment;
  bool login = false;
  bool isUserLoading = true;
  String? userName;
  @override
  void initState() {
    super.initState();
    getUserState();
    beginAlignment = Alignment.topRight;
    endAlignment = Alignment.bottomLeft;
    _startAnimation();
    currentTime = _getCurrentTime();
    // Timer to update the current time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = _getCurrentTime();
      });
    });
  }

  Future<void> getUserState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('userName');
    if (user != null) {
      setState(() {
        userName = user;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      userName = args; // Assign the argument to the userName variable
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer to avoid memory leaks
    super.dispose();
  }

  void checkBottomNavigationBar() {
    if (_currentIndex == 1) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BlogsScreen()));
    }
  }

  String _getCurrentTime() {
    // Format the current time
    return DateFormat('hh:mm:ss a').format(DateTime.now());
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Emergency Assistance",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const EmergencyDialogContent(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/maps"),
              child: const Text("Skip"),
            ),
          ],
        );
      },
    );
  }

  void _startAnimation() {
    // Toggle gradient direction every 2 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          // Toggle between two different gradients
          beginAlignment = beginAlignment == Alignment.topRight
              ? Alignment.topLeft
              : Alignment.topRight;
          endAlignment = endAlignment == Alignment.topLeft
              ? Alignment.bottomRight
              : Alignment.bottomLeft;
        });
        _startAnimation(); // Repeat the animation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userName != null) {
      login = true;
    }
    return Scaffold(
        body: Stack(children: [
          Stack(
            children: [
              Stack(
                children: [
                  AnimatedContainer(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: const [Colors.red, Colors.blue],
                        begin: beginAlignment,
                        end: endAlignment,
                      ),
                    ),
                    duration: const Duration(seconds: 2),
                    child: SafeArea(
                        child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.052),
                            const Center(
                              child: Text(
                                "Call Now",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.052),
                            ElevatedButton(
                              onPressed: () {
                                _showCustomDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.all(60),
                                elevation: 15,
                              ),
                              child: Image.asset("assets/call.gif",
                                  height: 40, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ),
                  SafeArea(
                    child: DraggableScrollableSheet(
                      initialChildSize:
                          0.35, // initial height (0.0 to 1.0, where 1.0 is full screen)
                      minChildSize: 0.35, // minimum height (0.0 to 1.0)
                      maxChildSize: 1, // maximum height (0.0 to 1.0)
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Scrollable content
                              SingleChildScrollView(
                                controller:
                                    scrollController, // Attach scroll controller here
                                child: Column(
                                  children: [
                                    const SizedBox(height: 60),
                                    // First Card
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15), // Rounded corners
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "assets/amb1.jpg",
                                                height: 130, // Set only height
                                                width: double
                                                    .infinity, // Set width to fill available space
                                                fit: BoxFit
                                                    .cover, // Ensure the aspect ratio is maintained
                                              ),
                                              const Text(
                                                "New Ambulance will be Introduced in future",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10),
                                              const Text(
                                                "Our goal is to revolutionize ambulance services by integrating AI-powered systems, smart vehicle tracking,...", // Truncated text
                                                style: TextStyle(fontSize: 16),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const FullTextScreen(),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  "Show More",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // First Card
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15), // Rounded corners
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "assets/amb1.jpg",
                                                height: 130, // Set only height
                                                width: double
                                                    .infinity, // Set width to fill available space
                                                fit: BoxFit
                                                    .cover, // Ensure the aspect ratio is maintained
                                              ),
                                              const Text(
                                                "New Ambulance will be Introduced in future",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10),
                                              const Text(
                                                "Our goal is to revolutionize ambulance services by integrating AI-powered systems, smart vehicle tracking,...", // Truncated text
                                                style: TextStyle(fontSize: 16),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const FullTextScreen(),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  "Show More",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Repeat the cards as needed...
                                  ],
                                ),
                              ),

                              // Fixed "Latest News" Text at the top
                              Positioned(
                                top: 0,
                                // Adjust the left position as needed
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Center(
                                    child: Text(
                                      "Latest News",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                  bottom: 20,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (login) {
                        Navigator.pushNamed(context, "/ChatAI");
                      } else {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'You must log in to perform this action.'),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior
                                    .floating, // Floating at the bottom
                                margin: EdgeInsets.all(16),
                              ),
                            );
                          }
                        });
                      }
                    },
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(
                      Icons.chat_bubble,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
          SafeArea(
            child: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 60),
                child: Container(
                  // Custom AppBar background color
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            login
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        userName: userName,
                                      ),
                                    ),
                                  )
                                : Navigator.pushNamed(context, "/LoginProfile");
                          },
                        ),
                        // Check if userName is null and display a default message if it is
                        Text(
                          "Hi, ${userName ?? 'Guest'}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ), // Default to 'Guest' if userName is null
                        IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/Settings');
                          },
                        ),
                        // IconButton(
                        //   icon: const Icon(
                        //     Icons.search,
                        //     color: Colors.white,
                        //   ),
                        //   onPressed: () {},
                        // ),
                      ],
                    ),
                  ]),
                )),
          )
        ]),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor:
              Colors.grey, // Optional, to make unselected items gray
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: "Blogs",
            ),
          ],
          currentIndex: _currentIndex, // Bind currentIndex to _currentIndex
          onTap: (int index) {
            setState(() {
              _currentIndex = index; // Update _currentIndex on tap
              checkBottomNavigationBar(); // Your additional logic if needed
            });
          },
        ));
  }
}
