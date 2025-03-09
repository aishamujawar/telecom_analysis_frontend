import 'package:flutter/material.dart';

class CustomerFeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Feedback & Reviews")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Customer Feedback",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildFeedbackCard("John Doe", "Great telecom services! Very satisfied."),
                  _buildFeedbackCard("Sarah Smith", "Churn analysis was very useful for our business."),
                  _buildFeedbackCard("Mike Johnson", "Would recommend their predictive analysis tools."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(String name, String feedback) {
    return Card(
      color: Colors.blueGrey[900],
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(feedback, style: TextStyle(color: Colors.white70)),
      ),
    );
  }
}
