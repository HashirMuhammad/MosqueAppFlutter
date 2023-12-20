import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Prayer Timing button click
                    Navigator.pushNamed(context, '/Updateprayer_timing');
                  },
                  child: Text('Edit Prayer Timing'),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Upload a Book button click
                    Navigator.pushNamed(context, '/upload_book');
                  },
                  child: Text('Upload a Book'),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Nikkah Booking List button click
                    Navigator.pushNamed(context, '/nikkah_booking_list');
                  },
                  child: Text('Nikkah Booking List'),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Answer a Question button click
                    Navigator.pushNamed(context, '/view_all_questionadmin');
                  },
                  child: Text('Answer Questions'),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Add a Dua button click
                    Navigator.pushNamed(context, '/add_dua');
                  },
                  child: Text('Add a Dua'),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 150, // Set the width of the box
                    height: 50, // Set the height of the box
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Announcements button click
                    Navigator.pushNamed(context, '/admin_announcements');
                  },
                  child: Text('Add Announcement'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
