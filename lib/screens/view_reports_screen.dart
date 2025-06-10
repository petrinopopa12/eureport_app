import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_report_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ViewReportsScreen extends StatelessWidget {
  const ViewReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Reports')),
        body: const Center(child: Text('Not logged in.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Reports')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reports found.'));
          }

          final reports = snapshot.data!.docs;

          return ListView.separated(
            itemCount: reports.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final report = reports[index].data();
              final title = report['title'] ?? 'No Title';
              final description = report['description'] ?? '';
              final timestamp = report['timestamp'] as Timestamp?;
              final dateStr = timestamp != null
                  ? '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}'
                  : 'No Date';

              return ListTile(
  leading: report['imageUrl'] != null
      ? Image.network(
          report['imageUrl'],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )
      : const Icon(Icons.description),
  title: Text(title),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(description),
      Text('Date: $dateStr'),
      const SizedBox(height: 4),
      GestureDetector(
        onTap: () async {
          final latitude = report['location']?['latitude'];
          final longitude = report['location']?['longitude'];

          if (latitude != null && longitude != null) {
            final Uri mapsUri = Uri.parse(
              'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
            );

            if (await canLaunchUrl(mapsUri)) {
              await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open Google Maps')),
              );
            }
          }
        },
        child: const Text(
          'View on Map',
          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
        ),
      ),
    ],
  ),
  trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: const Icon(Icons.edit, color: Colors.blue),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditReportScreen(
              reportId: reports[index].id,
              reportData: report,
            ),
          ),
        );
      },
    ),
    IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Report'),
            content: const Text('Are you sure you want to delete this report?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Delete')),
            ],
          ),
        );

        if (confirm == true) {
          final docId = reports[index].id;

          try {
            // Delete Firestore document
            await FirebaseFirestore.instance.collection('reports').doc(docId).delete();

            // Delete image from Firebase Storage if it exists
            final imageUrl = report['imageUrl'];
            if (imageUrl != null) {
              final ref = FirebaseStorage.instance.refFromURL(imageUrl);
              await ref.delete();
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report deleted successfully.')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete report: $e')),
            );
          }
        }
      },
    ),
  ],
),

);
            },
          );
        },
      ),
    );
  }
}
