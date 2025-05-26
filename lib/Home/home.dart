import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madadgaar/Home/emergency_dialog.dart';
import 'package:madadgaar/Profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Reporting/report_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String currentTime = '';
  final List<String> _cardImages = [
    "https://picsum.photos/id/237/400/200",
    "https://picsum.photos/id/1003/400/200",
    "https://picsum.photos/id/1025/400/200",
  ];
  final List<String> _cardTitles = [
    "Breaking News",
    "Tech Update",
    "Health Tips",
  ];
  final List<String> _cardSubtitles = [
    "Flutter 3.22 launched with major improvements.",
    "AI continues to transform software development.",
    "10 simple steps to boost your immune system.",
  ];

  final List<String> _cardDates = [
    "Posted: May 7, 2025",
    "Posted: May 6, 2025",
    "Posted: May 5, 2025",
  ];
  int _currentIndex = 0;
  Timer? _timer;
  late Alignment beginAlignment;
  late Alignment endAlignment;
  bool login = false;
  bool isUserLoading = true;
  String? userName;

  int _currentCardIndex = 0;
  final PageController _cardController = PageController();
  final List<String> _cardTexts = ['Emergency Tip 1', 'Emergency Tip 2', 'Emergency Tip 3'];

  @override
  void initState() {
    super.initState();
    getUserState();
    beginAlignment = Alignment.topRight;
    endAlignment = Alignment.bottomLeft;
    _startAnimation();
    currentTime = _getCurrentTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = _getCurrentTime();
      });
    });
    // Auto scroll cards every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_cardController.hasClients) {
        _currentCardIndex = (_currentCardIndex + 1) % _cardTexts.length;
        _cardController.animateToPage(
          _currentCardIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
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
      userName = args;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cardController.dispose();
    super.dispose();
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
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          beginAlignment = beginAlignment == Alignment.topRight
              ? Alignment.topLeft
              : Alignment.topRight;
          endAlignment = endAlignment == Alignment.topLeft
              ? Alignment.bottomRight
              : Alignment.bottomLeft;
        });
        _startAnimation();
      }
    });
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm:ss a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    if (userName != null) login = true;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          AnimatedContainer(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade500, Colors.purple.shade300], // Gradient colors
                begin: beginAlignment,
                end: endAlignment,
              ),
            ),
            duration: const Duration(seconds: 2),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.052),
                  const Center(
                    child: Text(
                      "Call Now for Help",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.052),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EmergencyReportScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.all(70),
                        elevation: 20,
                      ),
                      child: Image.asset("assets/call.gif", height: 50, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Header Section (Welcome, Profile, Settings)
          SafeArea(
            child: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 60),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        onPressed: () {
                          login
                              ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(userName: userName),
                            ),
                          )
                              : Navigator.pushNamed(context, "/LoginProfile");
                        },
                      ),
                      Text(
                        "Welcome, ${userName ?? 'Guest'}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/Settings');
                        },
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),

          // Latest News Text Above Cards (Adjusted Position)
          const Positioned(
            bottom: 230,  // Adjusted to make sure it doesn't overlap with other elements
            left: 110,
            child: Text(
              'Latest News: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // News/Tip Cards Section (Scroll through Cards)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _cardController,
                scrollDirection: Axis.horizontal,
                itemCount: _cardTexts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Background Image
                        SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Image.network(
                            _cardImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),

                        // Content Box
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _cardTitles[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _cardSubtitles[index],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _cardDates[index],
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
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
          ),
        ],
      ),
    );
  }
}
