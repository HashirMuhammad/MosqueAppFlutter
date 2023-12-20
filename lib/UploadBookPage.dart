import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UploadBookPage extends StatefulWidget {
  @override
  _UploadBookPageState createState() => _UploadBookPageState();
}

class _UploadBookPageState extends State<UploadBookPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Book'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/adminHome');
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                '../assets/images/admin2.jpg'), // Replace with the actual path to your image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Book Name'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'Book URL'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Retrieve the token from SharedPreferences
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  final String? token = prefs.getString('token');
        
                  // Make API request to http://localhost:3000/books
                  final apiUrl = 'http://localhost:3000/books';
                  final headers = {
                    'Content-Type': 'application/json',
                    'Authorization': '$token',
                  };
        
                  // Create the request payload
                  final payload = {
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'bookurl': urlController.text,
                  };
        
                  try {
                    final response = await http.post(
                      Uri.parse(apiUrl),
                      headers: headers,
                      body: jsonEncode(payload),
                    );
        
                    if (response.statusCode == 200) {
                      print('Book Uploaded Successfully');
                  Navigator.pushNamed(context, '/adminHome');
        
                      // Handle success, e.g., show a success message
                    } else {
                      print('Failed to upload book. Status code: ${response.statusCode}');
                      // Handle failure, e.g., show an error message
                    }
                  } catch (error) {
                    print('Error during book upload: $error');
                  }
                },
                child: Text('Upload Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
