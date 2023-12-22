import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MosqueSelectionPage extends StatefulWidget {
  @override
  _MosqueSelectionPageState createState() => _MosqueSelectionPageState();
}

class _MosqueSelectionPageState extends State<MosqueSelectionPage> {
  List<Map<String, dynamic>> areasWithMosques = [];
  String? selectedArea;
  List<Map<String, dynamic>> selectedMosques = [];
  List<DropdownMenuItem<String>> areaDropdownItems = [];
  Map<String, List<Map<String, dynamic>>> mosquesInAreas = {};

  @override
  void initState() {
    super.initState();
    fetchAreasWithMosques();
  }

  Future<void> fetchAreasWithMosques() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/areas-with-mosques'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        print('Fetched Data: $responseData');

        setState(() {
          areasWithMosques = List<Map<String, dynamic>>.from(responseData);
          areaDropdownItems = getAreaNames();
          mosquesInAreas = getMosquesInAreas();
        });
      } else {
        // Handle error
        print('Failed to load areas with mosques');
      }
    } catch (error) {
      // Handle network or server errors
      print('Error: $error');
    }
  }

  List<DropdownMenuItem<String>> getAreaNames() {
    return areasWithMosques
        .map((area) => DropdownMenuItem<String>(
            value: area['areaName'] as String,
            child: Text(area['areaName'] as String)))
        .toList();
  }

  Map<String, List<Map<String, dynamic>>> getMosquesInAreas() {
    return Map.fromIterable(
      areasWithMosques,
      key: (area) => area['areaName'] as String,
      value: (area) => (area['mosques'] as List<dynamic>)
          .map((mosque) => {
                'id': mosque['_id'] as String,
                'name': mosque['name'] as String,
              })
          .toList(),
    );
  }

  List<Widget> buildMosqueCheckboxes() {
    if (selectedArea != null && mosquesInAreas.containsKey(selectedArea)) {
      return (mosquesInAreas[selectedArea!] ?? []).map((mosque) {
        final mosqueId = mosque['id'] as String;
        final mosqueName = mosque['name'] as String;
        return CheckboxListTile(
          title: Text('$mosqueName'), // Replace with actual mosque information
          value: selectedMosques.any((m) => m['id'] == mosqueId),
          onChanged: (value) {
            setState(() {
              if (value != null && value) {
                selectedMosques.add({'id': mosqueId, 'name': mosqueName});
              } else {
                selectedMosques.removeWhere((m) => m['id'] == mosqueId);
              }
            });
          },
        );
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Mosque To Favourite'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedArea ??
                    areasWithMosques.first['areaName'] as String,
                items: areaDropdownItems,
                onChanged: (value) {
                  setState(() {
                    selectedArea = value;
                    selectedMosques =
                        []; // Reset selected mosques when area changes
                  });
                },
                style: TextStyle(fontSize: 18, color: Colors.black),
                isExpanded: true,
                elevation: 3,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildMosqueCheckboxes(),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (selectedArea != null && selectedMosques.isNotEmpty) {
                    print('Selected Area: $selectedArea');
                    print('Selected Mosques: $selectedMosques');

                    // Retrieve the token from SharedPreferences
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final String? token = prefs.getString('token');

                    // Make API request to http://localhost:3000/users/add-mosque
                    final apiUrl = 'http://localhost:3000/users/add-mosque';
                    final headers = {
                      'Content-Type': 'application/json',
                      'Authorization': '$token',
                    };

                    // Create the request payload
                    final mosqueIds =
                        selectedMosques.map((mosque) => mosque['id']).toList();
                    final payload = {'mosqueId': mosqueIds};

                    print(mosqueIds);

                    try {
                      final response = await http.post(
                        Uri.parse(apiUrl),
                        headers: headers,
                        body: jsonEncode(payload),
                      );
                      print(jsonEncode(payload));

                      if (response.statusCode == 200) {
                        print('API Response: ${response.body}');
                      } else {
                        print(
                            'API Request failed with status code: ${response.statusCode}');
                      }
                    } catch (error) {
                      print('Error during API request: $error');
                    }
                  } else {
                    print('Please select an area and at least one mosque');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Like Mosque',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
