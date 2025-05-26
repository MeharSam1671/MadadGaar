import 'dart:async';

import 'package:flutter/material.dart';

/// A full-screen loading widget with an AppBar titled "Madadgaar".
/// Displays a loader, a main title, and a subtitle that changes every 3 seconds.
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

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

  @override
  void initState() {
    super.initState();
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
