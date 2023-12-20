import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddNikkahPage extends StatefulWidget {
  @override
  _AddNikkahPageState createState() => _AddNikkahPageState();
}

class _AddNikkahPageState extends State<AddNikkahPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> addNikkahRecord() async {
    final apiUrl = 'http://localhost:3000/nikkah/add';
    final headers = {
      'Content-Type': 'application/json',
    };

    final payload = {
      'name': nameController.text,
      'cnic': cnicController.text,
      'phoneNo': phoneNoController.text,
      'address': addressController.text,
      'date': selectedDate.toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Nikkah record added successfully');
        // Handle success, e.g., navigate to another page
      } else {
        // Handle error
        print('Failed to add Nikkah record');
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
        title: Text('Book a Nikkah'),
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
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: cnicController,
                decoration: InputDecoration(labelText: 'CNIC'),
              ),
              TextField(
                controller: phoneNoController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Nikkah Date:'),
                  SizedBox(width: 8),
                  Text(
                    '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addNikkahRecord();
                },
                child: Text('Add Nikkah Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddNikkahPage(),
  ));
}
