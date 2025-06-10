import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String status = '';

  Future<void> submitReport() async {
  final title = titleController.text.trim();
  final description = descriptionController.text.trim();

  if (title.isEmpty || description.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all fields.')),
    );
    return;
  }

  try {
    // Request location permission using permission_handler
    final permissionStatus = await Permission.location.request();
    if (!permissionStatus.isGranted) {
        throw Exception('Location permission not granted');
}

    // Get current location
    final position = await Geolocator.getCurrentPosition();

    // Submit to Firestore
    await FirebaseFirestore.instance.collection('reports').add({
      'title': title,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'location': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted successfully!')),
    );

    titleController.clear();
    descriptionController.clear();
    Navigator.of(context).pop();

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to submit: $e')),
    );
  }
}

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitReport,
              child: const Text('Submit Report'),
            ),
            const SizedBox(height: 10),
            Text(status, style: const TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}