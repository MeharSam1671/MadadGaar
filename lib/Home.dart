import 'dart:async'; // Import the Timer class
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentTime = ''; // Initialize currentTime

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Text(
            "MadadGaar \n An Ambulance Calling System",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25 *
                  MediaQuery.of(context).textScaleFactor, // Scaled text size
              fontWeight: FontWeight.bold,
              color: Colors.white
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
                  title: Text("Allow Location"),
                  content: Text("Would you like to share your location?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/maps");
                      },
                      child: Text("Yes"),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(), backgroundColor: Colors.red, // Make the button circular
            padding: EdgeInsets.all(60), // Make button background transparent
            shadowColor: Colors.black,
            elevation: 15// Disable default shadow
          ),
          child:
              Image.asset("assets/call.gif", height: 40, color: Colors.white),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        // Wrap the following content in an Expanded widget to fill available space
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Row(
                  children: [
                    // Blue container on the left for the current time
                    Expanded(
                      child: Container(
                        height: 60, // Height of the list tile
                        color: Colors.blue, // Blue background color
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Geo Location Service",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    // White container on the right for the second ListTile
                    Expanded(
                      child: Container(
                        color: Colors.white, // White background color
                        child: ListTile(
                          subtitle: Text("Use GPS tracking System"),
                          trailing: Image.asset(
                            "assets/geolocation.gif",
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Row(
                  children: [
                    // Blue container on the left for the current time
                    Expanded(
                      child: Container(
                        height: 60, // Height of the list tile
                        color: Colors.blue, // Blue background color
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Live Tracking",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    // White container on the right for the second ListTile
                    Expanded(
                      child: Container(
                        color: Colors.white, // White background color
                        child: ListTile(
                          subtitle: Text("Tracking feature for users"),
                          trailing: Image.asset(
                            "assets/track.gif",
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Row(
                  children: [
                    // Blue container on the left for the current time
                    Expanded(
                      child: Container(
                        height: 60, // Height of the list tile
                        color: Colors.blue, // Blue background color
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Customer Support",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    // White container on the right for the second ListTile
                    Expanded(
                      child: Container(
                        color: Colors.white, // White background color
                        child: ListTile(
                          subtitle: Text("Customer support available 24/7"),
                          trailing: Image.asset(
                            "assets/customerservice.gif",
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
