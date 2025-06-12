import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
Future<Map<String, String>> _getUserLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception("Location services are disabled.");
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Location permissions are denied.");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception("Location permissions are permanently denied.");
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  if (placemarks.isNotEmpty) {
    Placemark place = placemarks[0];
    return {
      'city': place.locality ?? "Unknown",
      'country': place.country ?? "Unknown"
    };
  } else {
    throw Exception("No placemark found.");
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key,required this.home}) : super(key: key);
  final String? home;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final beginAlignment = Alignment.bottomCenter;
  late final endAlignment = Alignment.topCenter;

  @override
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    if (widget.home == "home") {
      _getUserLocation().then((location) {

        // After fetching location, wait then navigate
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacementNamed(
            '/Newhome',
            arguments: {
              'City': location['city'],
              'Country': location['country'],
            },
          );
        });
      }).catchError((e) {
        print("Location error: $e");
        Navigator.of(context).pushReplacementNamed('/Newhome');
      });
    }
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget buildColorfulText() {
    final letters = "MadadGaar".split("");
    final colors = [
      Colors.red,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.red,
      Colors.black,
      Colors.black,
      Colors.black,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(letters.length, (index) {
        final start = index * 0.1;
        final end = min(1.0, 0.6 + index * 0.1);
        final animation = Tween<double>(begin: 0.4, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              start,
              end,
              curve: Curves.easeInOut,
            ),
          ),
        );

        return ScaleTransition(
          scale: animation,
          child: Text(
            letters[index],
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              wordSpacing: 6,
              color: colors[index % colors.length],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 🔒 Disable back button on splash screen
      child: Scaffold(
        backgroundColor: Color(0xFFEFF3F9),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   'assets/ambulance.gif',
                //   width: 130,
                //   height: 130,
                // ),
                const SizedBox(height: 20),
                buildColorfulText(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: LinearProgressIndicator(color: Colors.pink,),
                )
                                ],
            ),
          ),
        ),
      ),
    );
  }

}
