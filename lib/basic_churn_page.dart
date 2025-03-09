import 'package:flutter/material.dart';
import 'dataset_page.dart';
import 'home_page.dart';
import 'churn_analysis_page.dart';
import 'what_is_churn_page.dart'; // Renamed from HomePage for clarity

class BasicChurnPage extends StatefulWidget {
  @override
  _BasicChurnPageState createState() => _BasicChurnPageState();
}

class _BasicChurnPageState extends State<BasicChurnPage> {
  int _selectedIndex = 0;

  // Pages for Bottom Navigation
  final List<Widget> _pages = [
    ChurnAnalysisPage(),
    WhatIsChurnPage(), // Renamed from HomePage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Basic Churn Insights")),
      body: Column(
        children: [
          Expanded(child: _pages[_selectedIndex]), // Switch between pages
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DatasetPage()),
              );
            },
            child: Text("View Dataset"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Text("Back to Basic Churn Details"),
          ),
          SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Churn Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'What is Churn?',
          ),
        ],
      ),
    );
  }
}

