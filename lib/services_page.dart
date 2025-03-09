import 'package:flutter/material.dart';
import 'package:telecom_churn_app/home_page.dart';
import 'churn_prediction_page.dart';
import 'basic_churn_page.dart';
import 'form_page.dart';

class TelecomServicesPage extends StatefulWidget {
  @override
  _TelecomServicesPageState createState() => _TelecomServicesPageState();
}

class _TelecomServicesPageState extends State<TelecomServicesPage> {
  String? expandedTitle;
  String? expandedDescription;
  IconData? expandedIcon;
  Widget? nextPage;

  void _showExpandedCard(String title, String description, IconData icon, Widget page) {
    setState(() {
      expandedTitle = title;
      expandedDescription = description;
      expandedIcon = icon;
      nextPage = page;
    });
  }

  void _closeExpandedCard() {
    setState(() {
      expandedTitle = null;
      expandedDescription = null;
      expandedIcon = null;
      nextPage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Our Services")),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                "assets/bggif.gif",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Service Information Card
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.blueGrey[900],
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Explore Our Services",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "We provide advanced telecom churn analysis, predictive insights, and customized service solutions.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Services List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildServiceCard(context, "Predict Churn", Icons.trending_up, ChurnPredictionPage(), 
                      "Our AI-driven churn prediction models help businesses analyze customer retention trends and reduce churn. "
                      "By identifying high-risk customers early, companies can take proactive steps such as targeted offers or improved customer engagement. "
                      "This service includes predictive analytics, churn score calculation, and actionable insights."),
                    SizedBox(height: 20),
                    _buildServiceCard(context, "Basic Churn Insights", Icons.analytics, BasicChurnPage(), 
                      "With our interactive churn insights, businesses gain a deeper understanding of their customers. "
                      "We provide comprehensive reports on churn patterns, segmentation analysis, and customer retention metrics. "
                      "This helps organizations develop better engagement strategies to increase loyalty and reduce churn."),
                    SizedBox(height: 20),
                    _buildServiceCard(context, "Request a Service", Icons.assignment, FormPage(), 
                      "We offer customized telecom data solutions for businesses looking to enhance their analytics capabilities. "
                      "Clients can request specialized services such as custom churn models, tailored reports, and consultation sessions. "
                      "Submit your request, and our team will provide a personalized solution to meet your business needs."),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          // Expanded Card View
          if (expandedTitle != null) _buildExpandedCard(),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, IconData icon, Widget page, String description) {
    return GestureDetector(
      onTap: () => _showExpandedCard(title, description, icon, page),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6, // Reduced width for a compact look
          child: Card(
            color: Colors.blueGrey[900],
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedCard() {
    return GestureDetector(
      onTap: _closeExpandedCard,
      child: Container(
        color: Colors.black.withOpacity(0.7), // Dims background
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75, // Reduced width
            height: MediaQuery.of(context).size.height * 0.5, // Reduced height
            child: Card(
              color: Colors.blueGrey[900],
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close Button (Top Right)
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: _closeExpandedCard,
                      ),
                    ),
                    Icon(expandedIcon, size: 60, color: Colors.blue),
                    SizedBox(height: 15),
                    Text(
                      expandedTitle!,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          expandedDescription!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage!));
                      },
                      child: Text("Explore"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
