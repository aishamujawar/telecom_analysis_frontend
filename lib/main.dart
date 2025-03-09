import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'home_page.dart';
import 'feedback_page.dart';
import 'services_page.dart';
import 'churn_prediction_page.dart';
import 'basic_churn_page.dart';
import 'dataset_page.dart';
import 'churn_analysis_page.dart';

void main() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(TelecomServicesApp());
}

class TelecomServicesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telecom Services',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark().copyWith(primary: Colors.blue),
      ),
      home: HomePage(),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Navigation", style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _buildDrawerItem(context, "Home", Icons.home, HomePage()),
          _buildDrawerItem(context, "Our Services", Icons.business,TelecomServicesPage()),
          _buildDrawerItem(context, "Feedback", Icons.feedback, CustomerFeedbackPage()),
          _buildDrawerItem(context, "Predict Churn", Icons.trending_up, ChurnPredictionPage()),
          _buildDrawerItem(context, "Basic Churn", Icons.analytics, BasicChurnPage()),
          _buildDrawerItem(context, "Dataset", Icons.dataset, DatasetPage()),
          _buildDrawerItem(context, "Churn Analysis", Icons.bar_chart, ChurnAnalysisPage()),
         
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}
