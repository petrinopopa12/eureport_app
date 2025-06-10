import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_report_screen.dart';
import 'view_reports_screen.dart';
import 'report_summary_chart_screen.dart'; // 👈 Add this import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003399),
        title: const Text(
          'EUReport Home',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Color(0xFFFFCC00), size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Welcome to EUReport',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003399),
                    ),
                  ),
                  Icon(Icons.star, color: Color(0xFFFFCC00), size: 28),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Logged in as: ${user?.email ?? 'User'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.report),
                label: const Text('Create Report'),
                style: _euButtonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateReportScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.list_alt),
                label: const Text('View My Reports'),
                style: _euButtonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ViewReportsScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.bar_chart),
                label: const Text('Report Summary'),
                style: _euButtonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReportSummaryChartScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _euButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF003399),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }
}
