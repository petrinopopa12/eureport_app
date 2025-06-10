import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? imageFile;
  String status = '';

  Future<void> pickImageFromCamera() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        imageFile = picked;
      });
    }
  }

  Future<String?> uploadImage(String docId) async {
  if (imageFile == null) return null;

  try {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('report_images')
        .child('$docId.jpg');

    final uploadTask = await storageRef.putFile(File(imageFile!.path));
    final downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    debugPrint('Image upload failed: $e');
    throw Exception('Image upload failed: $e');
  }
}

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
      final permissionStatus = await Permission.location.request();
      if (!permissionStatus.isGranted) {
        throw Exception('Location permission not granted');
      }

      final position = await Geolocator.getCurrentPosition();

      final docRef = FirebaseFirestore.instance.collection('reports').doc();

      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImage(docRef.id);
      }

      await docRef.set({
        'title': title,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'location': {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
        if (imageUrl != null) 'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully!')),
      );

      titleController.clear();
      descriptionController.clear();
      setState(() {
        imageFile = null;
      });

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
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: pickImageFromCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
            if (imageFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.file(File(imageFile!.path), height: 150),
              ),
            const SizedBox(height: 10),
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
