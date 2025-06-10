import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditReportScreen extends StatefulWidget {
  final String reportId;
  final Map<String, dynamic> reportData;

  const EditReportScreen({
    super.key,
    required this.reportId,
    required this.reportData,
  });

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  final ImagePicker picker = ImagePicker();
  XFile? newImageFile;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.reportData['title']);
    descriptionController = TextEditingController(text: widget.reportData['description']);
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        newImageFile = picked;
      });
    }
  }

  Future<String?> uploadNewImage(String reportId) async {
    if (newImageFile == null) return widget.reportData['imageUrl'];

    final storageRef = FirebaseStorage.instance.ref().child('report_images/$reportId.jpg');
    await storageRef.putFile(File(newImageFile!.path));
    return await storageRef.getDownloadURL();
  }

  Future<void> saveChanges() async {
    final newTitle = titleController.text.trim();
    final newDescription = descriptionController.text.trim();

    if (newTitle.isEmpty || newDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      final newImageUrl = await uploadNewImage(widget.reportId);

      await FirebaseFirestore.instance.collection('reports').doc(widget.reportId).update({
        'title': newTitle,
        'description': newDescription,
        if (newImageUrl != null) 'imageUrl': newImageUrl,
      });

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report updated.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  final oldImageUrl = widget.reportData['imageUrl'];

  return Scaffold(
    appBar: AppBar(title: const Text('Edit Report')),
    resizeToAvoidBottomInset: true,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Change Image'),
            ),
            const SizedBox(height: 10),
            if (newImageFile != null)
              Image.file(File(newImageFile!.path), height: 150)
            else if (oldImageUrl != null)
              Image.network(oldImageUrl, height: 150),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    ),
  );
}


  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}