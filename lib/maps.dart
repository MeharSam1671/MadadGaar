import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:madadgaar/Home/Home.dart';
import 'package:madadgaar/splashscreen.dart';

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
  late BitmapDescriptor ambulanceIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
  LatLng initialmaps = const LatLng(0, 0);
  LatLng initialmaps2 = const LatLng(32.1945477, 74.1994981);
  bool isLoading = true;
  late StreamSubscription<Position> locationSubscription;
  Set<Polyline> polylines = {}; // Store polyline data
  String? routeDistance;
  String? routeDuration;

  Future<void> setlocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show a message and return
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Location permission permanently denied")),
        );
      }
      return;
    }

    // If we reach here, permission is granted
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        initialmaps = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });

      _createRoute();
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
    _loadAmbulanceIcon();
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
  Future<void> _loadAmbulanceIcon() async {
    final ByteData byteData = await rootBundle.load('assets/ambulance.png');

    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: 100, // Change width here
      targetHeight: 100, // And height here
    );
    final frame = await codec.getNextFrame();
    final ui.Image image = frame.image;

    final byteDataResized = await image.toByteData(format: ui.ImageByteFormat.png);
    final resizedBytes = byteDataResized!.buffer.asUint8List();

    setState(() {
      ambulanceIcon = BitmapDescriptor.fromBytes(resizedBytes);
    });
  }  @override
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
          origin: PointLatLng(initialmaps2.latitude, initialmaps2.longitude),
          destination:
              PointLatLng(initialmaps.latitude, initialmaps.longitude),
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
    return
      WillPopScope(
          child:
      Scaffold(
        body: isLoading
            ? SplashScreen(home: "maps",)
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
              markers: {
                Marker(
                  markerId: const MarkerId("destination"),
                  position: initialmaps2,
                  infoWindow: const InfoWindow(
                    title: "Ambulance approaching",
                    snippet: "Your ambulance is on the way!",
                  ),
                  icon: ambulanceIcon,
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
      ),
          onWillPop: () async {
            bool? exit = await showDialog<bool>(
              context: context,
              barrierDismissible: false, // Prevent dismissing by tapping outside
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Warning: ", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                  ],
                ),
                content: const Text(
                  "Cancelling an ambulance request wastes valuable emergency resources. "
                      "Are you sure you want to cancel?\n\nRepeated cancellations may lead to service restrictions.",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("No", style: TextStyle(color: Colors.green)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: const Text("Yes, Cancel", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
            return exit ?? false;
          }

      );

  }
}
