import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementsPageadmin extends StatefulWidget {
  @override
  _AnnouncementsPageadminState createState() => _AnnouncementsPageadminState();
}

class _AnnouncementsPageadminState extends State<AnnouncementsPageadmin> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make an Announcement'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Enter Title'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Enter Description'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Retrieve the token from SharedPreferences
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  final String? token = prefs.getString('token');
        
                  // Make API request to http://localhost:3000/posts
                  final apiUrl = 'http://localhost:3000/posts';
                  final headers = {
                    'Content-Type': 'application/json',
                    'Authorization': '$token',
                  };
        
                  // Create the request payload
                  final payload = {
                    'mosqueid': '657a237bb6abc9d79202559c', // Replace with the actual mosque id
                    'title': titleController.text.trim(),
                    'description': descriptionController.text.trim(),
                  };
        
                  try {
                    final response = await http.post(
                      Uri.parse(apiUrl),
                      headers: headers,
                      body: jsonEncode(payload),
                    );
        
                    if (response.statusCode == 200) {
                      print('Announcement added successfully');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Announcement added successfully'),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      print('Failed to add announcement. Status code: ${response.statusCode}');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to add announcement'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  } catch (error) {
                    print('Error during API request: $error');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error during API request'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                child: Text('Add Announcement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
