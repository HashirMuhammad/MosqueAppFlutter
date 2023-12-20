import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateTimingPage extends StatefulWidget {
  @override
  _UpdateTimingPageState createState() => _UpdateTimingPageState();
}

class _UpdateTimingPageState extends State<UpdateTimingPage> {
  List<Map<String, dynamic>> prayers = [];

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/prayers/get'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          prayers = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        // Handle error
        print('Failed to load prayer times');
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
        title: Text('Prayer Times'),
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
        child: ListView.builder(
          itemCount: prayers.length,
          itemBuilder: (context, index) {
            final prayer = prayers[index];
            return Column(
              children: [
                ListTile(
                  title: Text(prayer['name'].toString()),
                  subtitle: Text(prayer['time'].toString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showUpdateDialog(prayer);
                    },
                    child: Text('Update Timing'),
                  ),
                ),
                Divider(), // Add a divider between each prayer item
              ],
            );
          },
        ),
      ),
    );
  }

  void _showUpdateDialog(Map<String, dynamic> prayer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController timeController = TextEditingController();
        timeController.text = prayer['time'].toString();

        return AlertDialog(
          title: Text('Update Timing for ${prayer['name']}'),
          content: TextField(
            controller: timeController,
            decoration: InputDecoration(labelText: 'New Timing'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                updatePrayerTiming(prayer['_id'].toString(), timeController.text);
                Navigator.of(context).pop();
              },
              child: Text('Update Timing'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updatePrayerTiming(String prayerId, String newTime) async {
    final apiUrl = 'http://localhost:3000/prayers/update/$prayerId';
    final headers = {
      'Content-Type': 'application/json',
    };

    final payload = {'time': newTime};

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Prayer timing updated successfully');
        fetchPrayerTimes(); // Refresh the prayer list after update
      } else {
        // Handle error
        print('Failed to update prayer timing');
      }
    } catch (error) {
      // Handle network or server errors
      print('Error: $error');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: UpdateTimingPage(),
  ));
}
