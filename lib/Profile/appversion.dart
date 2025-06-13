import 'package:flutter/material.dart';

class AppVersion extends StatefulWidget {
  const AppVersion({super.key});

  @override
  State<AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
  final String appVersion = "1.0.0";  // You can update this dynamically if needed
  final String buildNumber = "100";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Version'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MadadGaar',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Version: $appVersion',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Build Number: $buildNumber',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you for using MadadGaar! We continuously work to improve the app and provide the best emergency services to you.',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Center(
              child: Text(
                '© 2025 MadadGaar Project',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
