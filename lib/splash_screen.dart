import 'package:flutter/material.dart';
import 'dart:async';

import 'home_page.dart'; // The page that loads after splash

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentBrandIndex = 0;
  final List<String> brandLogos = [
    "assets/airtel.png", // Ensure these images are in assets
    "assets/vodafone.png",
    "assets/jio.png"
  ];

  @override
  void initState() {
    super.initState();

    // Start slideshow of brand logos
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        _currentBrandIndex = (_currentBrandIndex + 1) % brandLogos.length;
      });
    });

    // Navigate to HomePage after 8 seconds
    Timer(Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Logo
          AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(seconds: 2),
            child: Icon(Icons.trending_up, size: 100, color: Colors.blue), // Temporary logo
          ),
          SizedBox(height: 20),

          // Title
          Text(
            "Telecom Churn Analysis",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 30),

          // Loading Indicator
          CircularProgressIndicator(color: Colors.blue),
          SizedBox(height: 40),

          // "Brands That Trust Us" Text
          Text(
            "Brands That Trust Us",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),

          // Slideshow of Brand Logos
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: Image.asset(
              brandLogos[_currentBrandIndex],
              key: ValueKey<int>(_currentBrandIndex),
              width: 150,
              height: 80,
            ),
          ),
        ],
      ),
    );
  }
}
