import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NikkahBookingsPage extends StatefulWidget {
  @override
  _NikkahBookingsPageState createState() => _NikkahBookingsPageState();
}

class _NikkahBookingsPageState extends State<NikkahBookingsPage> {
  List<Map<String, dynamic>> nikkahBookings = [];

  @override
  void initState() {
    super.initState();
    fetchNikkahBookings();
  }

  Future<void> fetchNikkahBookings() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/nikkah/get-all'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          nikkahBookings = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        // Handle error
        print('Failed to load Nikkah bookings');
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
        title: Text('Nikkah Bookings'),
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
        child: nikkahBookings.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: nikkahBookings.length,
                itemBuilder: (context, index) {
                  final nikkahBooking = nikkahBookings[index];
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Name: ${nikkahBooking['name']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CNIC: ${nikkahBooking['cnic']}'),
                          Text('Phone Number: ${nikkahBooking['phoneNo']}'),
                          Text('Address: ${nikkahBooking['address']}'),
                          Text('Nikkah Date: ${nikkahBooking['date']}'),
                        ],
                      ),
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
    home: NikkahBookingsPage(),
  ));
}
