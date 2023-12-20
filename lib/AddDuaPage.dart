import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddDuaPage extends StatefulWidget {
  @override
  _AddDuaPageState createState() => _AddDuaPageState();
}

class _AddDuaPageState extends State<AddDuaPage> {
  TextEditingController duaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Dua'),
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
                controller: duaController,
                decoration: InputDecoration(labelText: 'Enter Dua'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Retrieve the token from SharedPreferences
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  final String? token = prefs.getString('token');
        
                  // Make API request to http://localhost:3000/duas
                  final apiUrl = 'http://localhost:3000/duas';
                  final headers = {
                    'Content-Type': 'application/json',
                    'Authorization': '$token',
                  };
        
                  // Create the request payload
                  final payload = {'dua': duaController.text.trim()};
        
                  try {
                    final response = await http.post(
                      Uri.parse(apiUrl),
                      headers: headers,
                      body: jsonEncode(payload),
                    );
        
                    if (response.statusCode == 200) {
                      print('Dua added successfully');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Dua added successfully'),
                        duration: Duration(seconds: 2),
                      ));
                  Navigator.pushNamed(context, '/adminHome');
        
                    } else {
                      print('Failed to add dua. Status code: ${response.statusCode}');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to add dua'),
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
                child: Text('Add Dua'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
