import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_report_screen.dart';
import 'view_reports_screen.dart'; // ✅ 1. Import the new screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_box, color: Colors.green),
                SizedBox(width: 8),
                Text('Logged in', style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            Text("Welcome, ${user?.email ?? 'User'}"),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.report),
              label: const Text('Create Report'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateReportScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text('View My Reports'), // ✅ 2. New button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewReportsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Location'),
              onPressed: () {
                // To be implemented
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Open Camera'),
              onPressed: () {
                // To be implemented
              },
            ),
          ],
        ),
      ),
    );
  }
}
