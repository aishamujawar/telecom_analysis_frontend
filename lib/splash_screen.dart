import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<String> brandLogos = [
    "assets/airtel.png",
    "assets/vodaphone.png",
    "assets/jio.png",
  ];

  @override
  void initState() {
    super.initState();
    print("Splash Screen Loaded"); // Debugging check

    // Animation controller for smooth scrolling (SLOWER SPEED)
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Slower movement
    )..repeat(reverse: false);

    // Navigate to HomePage after 8 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Logo
          AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(seconds: 2),
            child: Icon(Icons.trending_up, size: 100, color: Colors.blue),
          ),
          SizedBox(height: 20),

          // Title
          Text(
            "Telecom Churn Analysis",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 30),

          // "Brands That Trust Us" Text
          Text(
            "Brands That Trust Us",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),

          // Infinite Scrolling Brand Logos (Now Slower)
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      double moveX = -(_animationController.value * screenWidth * 1.2);
                      return Transform.translate(
                        offset: Offset(moveX, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return Image.asset(
                              brandLogos[index % brandLogos.length],
                              width: 100,
                              height: 60,
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
