import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with TickerProviderStateMixin {
  List<String> duas = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    fetchDuas();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchDuas() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/duas'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          duas = data.map((dua) => dua['dua'].toString()).toList();
        });
      } else {
        // Handle error
        print('Failed to load duas');
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
        title: Text('Home Page'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Button Row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Prayer Timing page
                        Navigator.pushNamed(context, '/prayer_timing');
                      },
                      child: Text('Prayer Timing'),
                    ),
                  ),
                  Container(
                    width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Mosque List page
                        Navigator.pushNamed(context, '/mosqueSelection');
                      },
                      child: Text('Mosque List'),
                    ),
                  ),
                  Container(
                    width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Books page
                        Navigator.pushNamed(context, '/books');
                      },
                      child: Text('Books'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Button Row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Qibla Direction page
                        Navigator.pushNamed(context, '/Qibla');
                      },
                      child: Text('Qibla Direction'),
                    ),
                  ),
                  Container(
                    width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Ask Imam page
                        Navigator.pushNamed(context, '/ask_imam');
                      },
                      child: Text('Ask Imam'),
                    ),
                  ),
                  Container(
                    width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Ask Imam page
                        Navigator.pushNamed(context, '/nikkah_booking');
                      },
                      child: Text('Nikkah Booking'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Announcements Button
              Container(
                width: 150, // Set the width of the box
                height: 50, // Set the height of the box
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Announcements page
                    Navigator.pushNamed(context, '/view_all_question');
                  },
                  child: Text('View Answers'),
                ),
              ),
              SizedBox(height: 16),
              // Announcements Button
              Container(
                width: 150, // Set the width of the box
                height: 50, // Set the height of the box
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Announcements page
                    Navigator.pushNamed(context, '/annoucements');
                  },
                  child: Text('Announcements'),
                ),
              ),
              SizedBox(height: 16),
              // Display animated duas
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return ListView.builder(
                      itemCount: duas.length,
                      itemBuilder: (context, index) {
                        final dua = duas[index];
                        final progress =
                            (_animationController.value * 100).toInt();
                        final duaLength = dua.length;

                        // Calculate the visible portion of the dua based on the animation progress
                        final visibleDua = dua.substring(
                            0, (duaLength * progress / 100).ceil());

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: Card(
                            elevation: 4.0,
                            child: ListTile(
                              title: Text(
                                '$visibleDua',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
