import 'package:flutter/material.dart';
import 'package:telecom_churn_app/home_page.dart';
import 'dart:async';
import 'main.dart';// The page that loads after splash

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 2),
              child: Icon(Icons.trending_up, size: 100, color: Colors.blue), // Temporary logo
            ),
            SizedBox(height: 20),
            Text(
              "Telecom Churn Analysis",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
