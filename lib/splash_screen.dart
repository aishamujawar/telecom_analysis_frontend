import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  
  final List<String> brandLogos = [
    "assets/airtel.png",
    "assets/vodaphone.png",
    "assets/jio.png",
  ];

  @override
  void initState() {
    super.initState();
    
    print("Splash Screen Loaded"); // Debugging check

    // Animation controller for continuous sliding effect
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Faster transition
    )..repeat(reverse: false);

    _slideAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(-1, 0),
    ).animate(_animationController);

    // Ensure splash screen stays for 8 seconds before moving to HomePage
    Future.delayed(Duration(seconds: 8), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
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
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      body: Center( // Centers everything
        child: Column(
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

            // Loading Indicator
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(height: 40),

            // "Brands That Trust Us" Text
            Text(
              "Brands That Trust Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),

            // Continuous Sliding Brand Logos
            SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width * 0.8, // Adjust width dynamically
              child: Stack(
                children: List.generate(brandLogos.length, (index) {
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FractionalTranslation(
                        translation: Offset(
                          _slideAnimation.value.dx + index.toDouble(),
                          0.0,
                        ),
                        child: Image.asset(
                          brandLogos[index],
                          width: 150,
                          height: 80,
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
