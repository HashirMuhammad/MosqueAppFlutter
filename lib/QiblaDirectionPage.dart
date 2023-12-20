import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';
import 'package:camera/camera.dart';


class QiblaDirectionPage extends StatefulWidget {
  @override
  _QiblaDirectionPageState createState() => _QiblaDirectionPageState();
}

class _QiblaDirectionPageState extends State<QiblaDirectionPage> {
  double _azimuth = 0.0;
  double _qiblaDirection = 0.0;
  LocationData? _currentLocation;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    initCompass();
    initLocation();
    initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> initCompass() async {
    FlutterCompass.events?.listen((event) {
      setState(() {
        _azimuth = event.heading ?? 0.0;
        calculateQiblaDirection();
      });
    });
  }

  Future<void> initLocation() async {
    var location = Location();
    try {
      _currentLocation = await location.getLocation();
      calculateQiblaDirection();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final CameraDescription firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await _cameraController!.initialize();
  }

  void calculateQiblaDirection() {
    if (_currentLocation != null) {
      double qiblaLatitude = 21.3891; // Kaaba's latitude
      double qiblaLongitude = 39.8579; // Kaaba's longitude

      double userLatitude = _currentLocation!.latitude!;
      double userLongitude = _currentLocation!.longitude!;

      double qiblaDirection = atan2(
        sin((qiblaLongitude - userLongitude) * (pi / 180)),
        cos(userLatitude * (pi / 180)) * tan(qiblaLatitude * (pi / 180)) -
            sin(userLatitude * (pi / 180)) * cos((qiblaLongitude - userLongitude) * (pi / 180)),
      );

      qiblaDirection = qiblaDirection * (180 / pi);

      setState(() {
        _qiblaDirection = qiblaDirection;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qibla Direction'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Transform.rotate(
                angle: ((_qiblaDirection - _azimuth) * pi / 180),
                child: Icon(Icons.navigation, size: 100.0),
              ),
            ),
            SizedBox(height: 16.0),
            if (_cameraController != null)
              AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              ),
          ],
        ),
      ),
    );
  }
}
