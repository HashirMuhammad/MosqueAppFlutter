import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllQuestionsPage extends StatefulWidget {
  @override
  _AllQuestionsPageState createState() => _AllQuestionsPageState();
}

class _AllQuestionsPageState extends State<AllQuestionsPage> {
  List<Map<String, dynamic>> allQuestions = [];

  @override
  void initState() {
    super.initState();
    fetchAllQuestions();
  }

  Future<void> fetchAllQuestions() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/qanda/get-all'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          allQuestions = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        // Handle error
        print('Failed to load all questions');
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
        title: Text('Questions and Answers'),
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
        child: allQuestions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: allQuestions.length,
                itemBuilder: (context, index) {
                  final question = allQuestions[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: ListTile(
                      title: Text(question['question'].toString()),
                      subtitle: question['answer'] != null
                          ? Text('Answer: ${question['answer']}')
                          : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AllQuestionsPage(),
  ));
}
