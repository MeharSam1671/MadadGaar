import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:madadgaar/splashscreen.dart';


Stream<Position> getLocationStream() {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  );
}

class Simplemaps extends StatefulWidget {
  const Simplemaps({super.key});

  @override
  State<Simplemaps> createState() => _MapsState();
}

class _MapsState extends State<Simplemaps> {
  late GoogleMapController mapController;
  LatLng initialmaps = const LatLng(0, 0);
  final LatLng destination = const LatLng(32.1945477, 74.1994981);
  bool isLoading = true;
  late StreamSubscription<Position> locationSubscription;
  Set<Polyline> polylines = {};
  String? routeDistance;
  String? routeDuration;

  Future<void> setLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Location permission permanently denied")),
        );
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        initialmaps = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to get location: $e")),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setLocation();
    locationSubscription = getLocationStream().listen((Position position) {
      setState(() {
        initialmaps = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });

      mapController.animateCamera(
        CameraUpdate.newLatLng(initialmaps),
      );
    });
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const SplashScreen(home: "maps")
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
            CameraPosition(target: initialmaps, zoom: 15.5),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController.animateCamera(
                CameraUpdate.newLatLng(initialmaps),
              );
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            polylines: polylines,
          ),
          if (routeDistance != null && routeDuration != null)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 34),
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                          color: Colors.white.withAlpha(242),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.directions_car,
                          color: Colors.blue),
                      const SizedBox(width: 12),
                      Text(
                        'ETA: $routeDuration',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        'Distance: $routeDistance',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.redAccent,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst,);
          }
          // Index 1 is current (Map), no need to push it again
          if (index == 2) {
            // Navigator.push(context, MaterialPageRoute(builder: (_) => const History()));
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Map',
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
