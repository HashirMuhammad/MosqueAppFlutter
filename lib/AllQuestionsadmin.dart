import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllQuestionsAdminPage extends StatefulWidget {
  @override
  _AllQuestionsAdminPageState createState() => _AllQuestionsAdminPageState();
}

class _AllQuestionsAdminPageState extends State<AllQuestionsAdminPage> {
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
        child: allQuestions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: allQuestions.length,
                itemBuilder: (context, index) {
                  final question = allQuestions[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnswerQuestionPage(
                              questionId: question['_id'].toString(),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(question['question'].toString()),
                        subtitle: question['answer'] != null
                            ? Text('Answer: ${question['answer']}')
                            : null,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class AnswerQuestionPage extends StatefulWidget {
  final String questionId;

  AnswerQuestionPage({required this.questionId});

  @override
  _AnswerQuestionPageState createState() => _AnswerQuestionPageState();
}

class _AnswerQuestionPageState extends State<AnswerQuestionPage> {
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer Question'),
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
                controller: answerController,
                decoration: InputDecoration(labelText: 'Your Answer'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Submit the answer using the put API
                  submitAnswer();
                },
                child: Text('Submit Answer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitAnswer() async {
    final apiUrl = 'http://localhost:3000/qanda/answer/${widget.questionId}';
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
        print('Answer submitted successfully');
        Navigator.pop(
            context); // Navigate back after successful answer submission
      } else {
        // Handle error
        print('Failed to submit answer');
      }
    } catch (error) {
      // Handle network or server errors
      print('Error: $error');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AllQuestionsAdminPage(),
  ));
}
