import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

Future<void> _pushLocationToFirestore(Position position) async {
  try {
    // Get the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Push the user's location to Firestore
    await firestore
        .collection('users')
        .doc('user_id') // Replace with actual user ID
        .set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (kDebugMode) {
      print('Location updated successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error pushing location to Firestore: $e');
    }
  }
}

class _MapsState extends State<Maps> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(0.0, 0.0); // Default location
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() async {
    int value = 0;
    try {
      while (true) {
        if (kDebugMode) {
          print("Position $value");
        }
        value++;

        // Attempt to get the current location
        Position position = await getCurrentLocation();

        // Update the state with the new location
        setState(() {
          _center = LatLng(position.latitude, position.longitude);
          _isMapReady = true;
        });

        // Delay for 1 second before the next iteration
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      // Handle the error
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If location services are not enabled, you can prompt the user to enable them
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, so you cannot access location
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: _isMapReady
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0, // Adjust zoom level as needed
              ),

              markers: {
                const Marker(
                  markerId: MarkerId('ambulance'),
                  position: LatLng(32.201217, 74.206839),
                ),
              },
              myLocationEnabled:
                  true, // Enable the built-in blue dot for current location
              myLocationButtonEnabled: true, // Show the location button
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
