import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Our Project',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'This project, MadadGaar, is an autonomous dispatching and tracking system aimed at providing emergency ambulance services quickly and efficiently. '
                  'It is inspired by the Rescue 1122 app, which is a well-known emergency service application in Pakistan offering quick response for medical emergencies, fire, and rescue operations. '
                  'MadadGaar aims to improve on these services by adding advanced live tracking, chatbot assistance, and better dispatching algorithms to ensure faster and more effective emergency support.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'Team Members',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const ListTile(
              leading: CircleAvatar(
                child: Text('HS'),
              ),
              title: Text('Hafiz Abdul Samad'),
              subtitle: Text('Team Member & Developer'),
            ),
            const ListTile(
              leading: CircleAvatar(
                child: Text('MS'),
              ),
              title: Text('Muhammad Saadullah Zafar'),
              subtitle: Text('Team Member & Developer'),
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
            )
          ],
        ),
      ),
    );
  }
}
