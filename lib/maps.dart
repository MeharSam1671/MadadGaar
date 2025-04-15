import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

Stream<Position> getLocationStream() {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update when the user moves 10 meters
    ),
  );
}

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late GoogleMapController mapController;
  LatLng initialmaps = const LatLng(0, 0);
  LatLng initialmaps2 = const LatLng(31.622729, 74.286317);
  bool isLoading = true;
  late StreamSubscription<Position> locationSubscription;
  Set<Polyline> polylines = {}; // Store polyline data

  Future<void> setlocation() async {
    Position position = await Geolocator.getCurrentPosition(

        ///desiredAccuracy: LocationAccuracy.high,
        );
    setState(() {
      initialmaps = LatLng(position.latitude, position.longitude);
      isLoading = false;
    });

    _createRoute(); // Call to draw the polyline
  }

  @override
  void initState() {
    super.initState();
    setlocation();
    locationSubscription = getLocationStream().listen((Position position) {
      setState(() {
        initialmaps = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });

      mapController
          .animateCamera(CameraUpdate.newLatLng(initialmaps)); // Smooth follow
      _createRoute(); // Recalculate route
    });
  }

  @override
  void dispose() {
    locationSubscription.cancel(); // Cancel stream to avoid memory leaks
    super.dispose();
  }

  Future<void> _createRoute() async {
    List<LatLng> polylineCoordinates = await getPolylinePoints();
    setState(() {
      polylines.clear(); // Clear previous polyline
      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 4,
        ),
      );
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    try {
      List<LatLng> polylineCoordinates = [];
      PolylinePoints polylinePoints = PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyCBQv1_43-rVkUZFCftBVHFeGW8XkmR9Is",
        PointLatLng(initialmaps.latitude, initialmaps.longitude),
        PointLatLng(initialmaps2.latitude, initialmaps2.longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        for (PointLatLng point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        if (kDebugMode) {
          print(result.errorMessage);
        }
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("No route found")));
        }
        return [];
      }

      return polylineCoordinates;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unable to fetch the routes")));
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: initialmaps, zoom: 12),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                mapController.animateCamera(
                  CameraUpdate.newLatLng(initialmaps),
                );
              },
              markers: {
                Marker(
                    markerId: const MarkerId("destination"),
                    position: initialmaps2),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: polylines, // Add the polyline to the map
            ),
    );
  }
}
