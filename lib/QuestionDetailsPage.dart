import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QandAPage extends StatefulWidget {
  @override
  _QandAPageState createState() => _QandAPageState();
}

class _QandAPageState extends State<QandAPage> {
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/qanda/get-all'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          questions = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        // Handle error
        print('Failed to load questions');
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
        title: Text('Questions'),
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
        child: questions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return ListTile(
                    title: Text(question['question'].toString()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionDetailsPage(questionId: question['_id']),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class QuestionDetailsPage extends StatefulWidget {
  final String questionId;

  QuestionDetailsPage({required this.questionId});

  @override
  _QuestionDetailsPageState createState() => _QuestionDetailsPageState();
}

class _QuestionDetailsPageState extends State<QuestionDetailsPage> {
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer the Questions'),
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
              Text('Question: ${widget.questionId}'), // Display the question or any other details
              SizedBox(height: 16),
              TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: 'Your Answer'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addAnswer();
                },
                child: Text('Add Answer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addAnswer() async {
    final apiUrl = 'http://localhost:3000/qanda/add-answer/${widget.questionId}';
    final headers = {
      'Content-Type': 'application/json',
    };

    final payload = {'answer': answerController.text};

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Answer added successfully');
        Navigator.pop(context); // Navigate back after successful addition
      } else {
        // Handle error
        print('Failed to add answer');
      }
    } catch (error) {
      // Handle network or server errors
      print('Error: $error');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: QandAPage(),
  ));
}
