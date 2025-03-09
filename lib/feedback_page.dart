import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'submit_feedback_page.dart';

class FeedbackPage extends StatelessWidget {
  final List<Map<String, String>> feedbacks = [
    {
      "name": "John Anderson",
      "position": "Senior Analyst",
      "company": "AT&T",
      "review": "Using Telecom Churn Analysis, we identified high-risk customers and reduced churn by 15%. The insights were invaluable, and the predictive models provided highly accurate results. The dashboard is easy to use, making data-driven decisions seamless for our team.",
    },
    {
      "name": "Emily Carter",
      "position": "Telecom Consultant",
      "company": "Verizon",
      "review": "This platform transformed the way we handle customer retention. We implemented the churn prevention strategies suggested by the analysis, and it significantly improved our customer loyalty metrics. The AI-driven models are exceptional and easy to integrate into our systems.",
    },
    {
      "name": "Michael Thompson",
      "position": "Operations Manager",
      "company": "T-Mobile",
      "review": "The detailed analytics reports helped us optimize our customer service approach. We were able to proactively reach out to at-risk customers and increase retention by 20%. The data accuracy and visualization tools are the best we've seen so far!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Feedback"), backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 📜 Brief Introduction
                      _buildSectionTitle("What Telecom Professionals Say"),
                      const SizedBox(height: 10),
                      _buildDescription(
                          "Leading telecom analysts, consultants, and managers share their experiences using our platform."),
                      const SizedBox(height: 30),

                      // 🎠 Customer Reviews in Carousel
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 250, // ✅ Adjusted for Small Screens
                          autoPlay: true,
                          enlargeCenterPage: true,
                          autoPlayInterval: Duration(seconds: 4),
                          viewportFraction: 0.9,
                        ),
                        items: feedbacks.map((feedback) {
                          return _buildFeedbackCard(feedback);
                        }).toList(),
                      ),

                      const SizedBox(height: 40),

                      // 📌 Feedback & Improvements Section
                      _buildSectionTitle("How We Improved Based on Feedback"),
                      const SizedBox(height: 10),
                      _buildImprovementCard(
                          "🛠 More Interactive Visualizations",
                          "We added real-time charts and improved UX for better insights."),
                      _buildImprovementCard(
                          "📞 Enhanced Customer Support",
                          "We introduced AI-based support and reduced response time by 40%."),
                      _buildImprovementCard(
                          "📊 Industry Benchmarking",
                          "Added competitor comparisons to help companies position themselves better."),

                      const SizedBox(height: 40),

                      // 📝 Submit Feedback Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitFeedbackPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Submit Your Feedback"),
                      ),

                      const SizedBox(height: 40),

                      // 📞 Contact Us Section
                      _buildSectionTitle("Contact Us"),
                      const SizedBox(height: 10),
                      _buildContactCard(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 📌 Function to Build Section Titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  // 📌 Function to Build Description Text
  Widget _buildDescription(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.white70),
    );
  }

  // 🎠 Function to Build Feedback Cards
  Widget _buildFeedbackCard(Map<String, String> feedback) {
    return Card(
      color: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Text(
                _getInitials(feedback["name"]!), // Show initials
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feedback["name"]!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              "${feedback['position']} • ${feedback['company']}",
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              feedback["review"]!,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Function to Build Improvement Cards
  Widget _buildImprovementCard(String title, String description) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 5),
            Text(description, style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // 📞 Function to Build Contact Card
  Widget _buildContactCard() {
    return Card(
      color: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildContactTile(Icons.phone, "+91- 8360773532"),
            _buildContactTile(Icons.email, "support@telecomservices.com"),
            _buildContactTile(Icons.location_on, "Mumbai, India"),
          ],
        ),
      ),
    );
  }

  // 📌 Function to Build Contact Tiles
  Widget _buildContactTile(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  // 📌 Function to Get Initials from Name
  String _getInitials(String name) {
    List<String> nameParts = name.split(" ");
    if (nameParts.length > 1) {
      return "${nameParts[0][0]}${nameParts[1][0]}"; // First letter of first & last name
    } else {
      return nameParts[0][0]; // First letter if only one word
    }
  }
}
