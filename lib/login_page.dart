import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login Page'),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../assets/images/login.jpg'), // Replace with the actual path to your image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                style: TextStyle(color: Colors.white),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final response = await http.post(
                      Uri.parse('http://localhost:3000/login'),
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode({
                        'email': emailController.text,
                        'password': passwordController.text,
                      }),
                    );
                    print(emailController.text);
                    print(passwordController.text);

                    print(response.statusCode);
                    if (response.statusCode == 200) {
                      final data = json.decode(response.body);
                      final token = data['token'];
                      final role = data['role'];
                      print(token);
                      print(role);

                      // Store the token securely and navigate to the home page
                      await SharedPreferences.getInstance().then((prefs) {
                        prefs.setString('token', token);
                        prefs.setString('role', role);
                      });

                      if (role == 'user') {
                        Navigator.pushReplacementNamed(context, '/userHome');
                      } else if (role == 'admin') {
                        Navigator.pushReplacementNamed(context, '/adminHome');
                      } else {
                        // Handle unrecognized role or navigate to a default route
                        Navigator.pushReplacementNamed(context, '/');
                      }

                      print('valid login');
                    } else {
                      // Handle invalid login
                      print('Invalid login');
                    }
                  } catch (error) {
                    // Handle network or server errors
                    print('Error: $error');
                  }
                },
                child: Text('Login',
                style: TextStyle(color: Colors.blue),),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: Text(
                  'Create an account',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
