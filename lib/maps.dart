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
  LatLng initialmaps2 = const LatLng(32.1945477, 74.1994981);
  bool isLoading = true;
  late StreamSubscription<Position> locationSubscription;
  Set<Polyline> polylines = {}; // Store polyline data
  String? routeDistance;
  String? routeDuration;

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
        googleApiKey: "AIzaSyCQd0aTxNVJZ9C6Oq9aGUUG3AAN2Yncve0",
        request: PolylineRequest(
          origin: PointLatLng(initialmaps.latitude, initialmaps.longitude),
          destination:
              PointLatLng(initialmaps2.latitude, initialmaps2.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        for (PointLatLng point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        // Set distance and duration from result
        setState(() {
          routeDistance = result.distanceTexts?[0];
          routeDuration = result.durationTexts?[0];
        });
      } else {
        if (kDebugMode) {
          print(result.errorMessage);
        }
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("No route found")));
        }
        setState(() {
          routeDistance = null;
          routeDuration = null;
        });
        return [];
      }

      return polylineCoordinates;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unable to fetch the routes")));
      }
      setState(() {
        routeDistance = null;
        routeDuration = null;
      });
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Madadgaar'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
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
                      position: initialmaps2,
                      infoWindow: const InfoWindow(
                        title: "Ambulance approaching",
                        snippet: "Your ambulance is on the way!",
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  polylines: polylines, // Add the polyline to the map
                ),
                if (routeDistance != null && routeDuration != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Text(
                              'Distance: $routeDistance',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
