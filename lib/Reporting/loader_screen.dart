import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madadgaar/Maps/maps.dart';
import 'package:madadgaar/utils/api_controller.dart';
import 'package:madadgaar/utils/socket_client.dart';

var backendUrl = "http://10.0.2.2:4000/api";

/// A full-screen loading widget with an AppBar titled "Madadgaar".
/// Displays a loader, a main title, and a subtitle that changes every 3 seconds.
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.selectedScale,
    required this.selectedCategory,
    required this.selectedSubcategory,
  });

  final double latitude, longitude;
  final String selectedScale, selectedCategory, selectedSubcategory;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final List<String> _loadingMessages = [
    'Contacting dispatch',
    'Reporting location',
    'Sending emergency details',
    'Awaiting confirmation',
    'Please hold on',
  ];
  late Timer _timer;
  int _currentIndex = 0;

  final apiController = ApiController();
  final socketClient = SocketClient(baseUrl: 'http://10.0.2.2:4000/api');

  Future<void> submitIncident(BuildContext context) async {
    // if (widget.selectedScale == null ||
    //     widget.selectedCategory == null ||
    //     widget.selectedSubcategory == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //         content: Text('Please select all options before submitting.')),
    //   );
    //   return;
    // }

    // Here we will handle the submission logic
    if (kDebugMode) {
      print('Incident to be Submitted:');
    }
    final int epochMilliseconds = DateTime.now().millisecondsSinceEpoch;

    http.Response response = await apiController.post(
      "/emergency",
      {
        "lat": widget.latitude,
        "lng": widget.longitude,
        "category": widget.selectedCategory,
        "subcategory": widget.selectedSubcategory,
        "timestamp": epochMilliseconds,
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incident reported successfully!')),
        );
      }
      if (kDebugMode) {
        print('Incident reported successfully!');
        print('Response: ${response.body}');
      }

      await socketClient.connect();

      Future<void> handleDispatched(dynamic data) async {
        if (kDebugMode) {
          print('Dispatched data received: $data');
        }

        // Navigate to the map screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Maps(
              latitude: data['lat'] ?? widget.latitude,
              longitude: data['lng'] ?? widget.longitude,
              eta: data['duration'] ?? 'N/A',
              distance: data['distance'] ?? 'N/A',
              driverName: data['driverName'] ?? 'Unknown',
            ),
          ),
        );
      }

      socketClient.on('dispatched', (data) => handleDispatched(data));
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to report incident: ${response.body}')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    submitIncident(context);
    // Update the subtitle every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _loadingMessages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Madadgaar'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Loader
            const CircularProgressIndicator(
              strokeWidth: 4,
            ),
            const SizedBox(height: 24),
            // Main title
            const Text(
              'Reporting Emergency',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle that updates
            Text(
              _loadingMessages[_currentIndex],
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
