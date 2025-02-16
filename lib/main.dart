import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import for FFI database support
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'home_page.dart';
import 'dataset_page.dart';
import 'churn_analysis_page.dart';
import 'churn_prediction_page.dart';

void main() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb; // Use Web database (IndexedDB)
  } else {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; // Use normal SQLite on mobile/desktop
  }

  runApp(TelecomChurnApp());
}

class TelecomChurnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telecom Churn Analysis',
      home: BottomNavBar(), // Use BottomNavBar as the home page
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0; // Track the selected index

  // List of pages to navigate to
  final List<Widget> _pages = [
    HomePage(),
    DatasetPage(),
    ChurnAnalysisPage(),
    ChurnPredictionPage(), // Prediction page
  ];

  // Handle bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Current selected index
        onTap: _onItemTapped, // Handle item taps
        selectedItemColor: Colors.blue, // Color of the selected item
        unselectedItemColor: Colors.grey, // Color of unselected items
        showUnselectedLabels: true, // Show labels for unselected items
        type: BottomNavigationBarType.fixed, // Fixed type for more than 3 items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'Dataset',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up), // Icon for prediction
            label: 'Prediction', // Label for prediction
          ),
        ],
      ),
    );
  }
}