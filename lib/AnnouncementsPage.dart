import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementsPage extends StatefulWidget {
  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  List<Map<String, dynamic>> announcements = [];

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    try {
      // Retrieve the token from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      // Make API request to http://localhost:3000/user-posts
      final apiUrl = 'http://localhost:3000/user-posts';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      };

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        print('Fetched Data: $responseData');

        setState(() {
          announcements = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        // Handle error
        print('Failed to load announcements');
      }
    } catch (error) {
      // Handle network or server errors
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/userHome');
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                '../assets/images/home.jpg'), // Replace with the actual path to your image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Announcements:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              if (announcements.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: announcements.map((announcement) {
                    final title = announcement['title'] as String;
                    final description = announcement['description'] as String;
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 12),
                      child: ListTile(
                        title: Text(title),
                        subtitle: Text(description),
                      ),
                    );
                  }).toList(),
                )
              else
                Text('No announcements available.'),
            ],
          ),
        ),
      ),
    );
  }
}
