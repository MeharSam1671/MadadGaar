import 'dart:async'; // Import the Timer class
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentTime = ''; // Initialize currentTime
  int _currentIndex = 0; // Declare _currentIndex for BottomNavigationBar

  @override
  void initState() {
    super.initState();
    currentTime = _getCurrentTime();
    // Update time every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = _getCurrentTime();
      });
    });
  }

  String _getCurrentTime() {
    // Format the current time
    return DateFormat('hh:mm:ss a').format(DateTime.now());
  }

  Future<void> _checkAndNavigateToMap() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? const Text(
          "Home",
          style: TextStyle(color: Colors.black),
        )
            : const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.blue],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),

          // Content above bottom draggable container
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding:
                EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                child: const Text(
                  "MadadGaar \n An Ambulance Calling System",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Allow Location"),
                        content: const Text(
                            "Would you like to share your location?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/maps');
                              _checkAndNavigateToMap();
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );
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

          // DraggableScrollableSheet for the Bottom Section
          DraggableScrollableSheet(
            initialChildSize: 0.4, // Default size (40% of screen)
            minChildSize: 0.4, // Minimum size
            maxChildSize: 1, // Maximum size
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildListItem("Geo Location Service",
                        "Use GPS tracking System", "assets/geolocation.gif"),
                    _buildListItem("Live Tracking",
                        "Tracking feature for users", "assets/track.gif"),
                    _buildListItem("Customer Support",
                        "Customer support available 24/7", "assets/customerservice.gif"),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
    );
  }

  Widget _buildListItem(String title, String subtitle, String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              color: Colors.blue,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20)),color: Colors.red,),

              
              child: ListTile(
                subtitle: Text(subtitle,style: TextStyle(color: Colors.white),),
                trailing: Image.asset(
                  assetPath,
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
