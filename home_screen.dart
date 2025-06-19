// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _navigateToPreview() {
    if (_image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(imagePath: _image!.path),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick an image first")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("String Art Generator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null)
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.file(_image!, fit: BoxFit.cover),
                )
              else
                const Text("No image selected"),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _getImage,
                icon: const Icon(Icons.image),
                label: const Text("Select Image"),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _navigateToPreview,
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Generate String Art"),
              ),

              // Nail Count Reference Table
              const SizedBox(height: 40),
              const Text("Nail Count vs Detail Quality",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Nail Range")),
                  DataColumn(label: Text("Detail Level")),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text("1 - 100")), DataCell(Text("Very Low"))]),
                  DataRow(cells: [DataCell(Text("100 - 200")), DataCell(Text("Low to Medium"))]),
                  DataRow(cells: [DataCell(Text("200 - 300")), DataCell(Text("Good"))]),
                  DataRow(cells: [DataCell(Text("300 - 500")), DataCell(Text("High"))]),
                  DataRow(cells: [DataCell(Text("500 - 1000+")), DataCell(Text("Very High"))]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}