import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddQuestionPage extends StatefulWidget {
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  TextEditingController questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
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
                controller: questionController,
                decoration: InputDecoration(labelText: 'Question'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addQuestion();
                },
                child: Text('Add Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addQuestion() async {
    final apiUrl = 'http://localhost:3000/qanda/add-question';
    final headers = {
      'Content-Type': 'application/json',
    };

    final payload = {'question': questionController.text};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Question added successfully');
        Navigator.pop(context); // Navigate back after successful addition
      } else {
        // Handle error
        print('Failed to add question');
      }
    } catch (error) {
      // Handle network or server errors
      print('Error: $error');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AddQuestionPage(),
  ));
}
