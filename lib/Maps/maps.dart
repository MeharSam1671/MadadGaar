import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:madadgaar/splashscreen.dart';

Stream<Position> getLocationStream() {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  );
}

Future<String> getDarkMapStyle() async =>
    await rootBundle.loadString('assets/dark_map.json');

Future<String> getLightMapStyle() async => ""; // Default light style

class Maps extends StatefulWidget {
  const Maps(
      {super.key,
      this.latitude = 0,
      this.longitude = 0,
      this.eta = 'N/A',
      this.distance = 'N/A',
      this.driverName = 'Unknown'});
  final double latitude;
  final double longitude;
  final String eta, distance, driverName;

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late GoogleMapController mapController;
  late BitmapDescriptor ambulanceIcon;
  LatLng initialmaps = const LatLng(0, 0);
  late LatLng initialmaps2;
  bool isLoading = true;
  bool isDarkMode = true;
  late StreamSubscription<Position> locationSubscription;
  Set<Polyline> polylines = {};
  String? routeDistance;
  String? routeDuration;
  String? mapStyle;


  @override
  void initState() {
    super.initState();
    initialmaps2 = LatLng(widget.latitude, widget.longitude);
    _loadAmbulanceIcon();
    _initializeLocation();
    locationSubscription = getLocationStream().listen((position) {
      setState(() {
        initialmaps = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
      mapController.animateCamera(CameraUpdate.newLatLng(initialmaps));
      _createRoute();
    });
  }

  Future<void> _initializeLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnack("Location permission denied");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _showSnack("Location permission permanently denied");
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
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

  Future<void> _loadAmbulanceIcon() async {
    final byteData = await rootBundle.load('assets/ambulance.png');
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: 100,
      targetHeight: 100,
    );
    final frame = await codec.getNextFrame();
    final bytes =
        (await frame.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();
    setState(() {
      ambulanceIcon = BitmapDescriptor.bytes(bytes);
    });
  }

  void _showSnack(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _createRoute() async {
    try {
      List<LatLng> coordinates = [];
      final result = await PolylinePoints().getRouteBetweenCoordinates(
        googleApiKey: "AIzaSyCQd0aTxNVJZ9C6Oq9aGUUG3AAN2Yncve0",
        request: PolylineRequest(
          origin: PointLatLng(initialmaps2.latitude, initialmaps2.longitude),
          destination: PointLatLng(initialmaps.latitude, initialmaps.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        coordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        setState(() {
          routeDistance = result.distanceTexts?.first;
          routeDuration = result.durationTexts?.first;
          polylines = {
            Polyline(
              polylineId: const PolylineId("route"),
              points: coordinates,
              color: Colors.blue,
              width: 4,
            ),
          };
        });
      } else {
        _showSnack("No route found");
      }
    } catch (_) {
      _showSnack("Unable to fetch routes");
    }
  }

  Future<void> _toggleMapStyle() async {
    isDarkMode = !isDarkMode;
    mapStyle = isDarkMode ? await getDarkMapStyle() : await getLightMapStyle();
    setState(() {});
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;


        final exit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Warning", style: TextStyle(color: Colors.red)),
            content: const Text(
              "Cancelling an ambulance request wastes valuable emergency resources. Are you sure?",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("No")),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text("Yes, Cancel"),
              ),
            ],
          ),
        );
        if (exit == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: isLoading
            ? const SplashScreen(home: "maps")
            : Stack(
                children: [
                  GoogleMap(
                    style: mapStyle,
                    initialCameraPosition:
                        CameraPosition(target: initialmaps, zoom: 15.5),
                    onMapCreated: (controller) async {
                      mapController = controller;
                      mapStyle = await getDarkMapStyle(); // default style
                      setState(() {}); // triggers initial style load
                      mapController
                          .animateCamera(CameraUpdate.newLatLng(initialmaps));
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("destination"),
                        position: initialmaps2,
                        icon: ambulanceIcon,
                        infoWindow:
                            const InfoWindow(title: "Ambulance approaching"),
                      )
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    polylines: polylines,
                  ),
                  if (routeDistance != null && routeDuration != null)
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey[900]!.withAlpha(230)
                              : Colors.white.withAlpha(242),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Driver Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error)),
                                  const SizedBox(height: 4),
                                  Text("Muhammad Saadullah Zafar",
                                      style: TextStyle(color: textColor)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.timer_outlined,
                                          color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text("ETA: $routeDuration",
                                          style: TextStyle(color: textColor)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.route,
                                          color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text("Distance: $routeDistance",
                                          style: TextStyle(color: textColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 50,
                    left: 10,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: _toggleMapStyle,
                      child: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
