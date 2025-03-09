import 'package:flutter/material.dart';

class SubmitFeedbackPage extends StatefulWidget {
  @override
  _SubmitFeedbackPageState createState() => _SubmitFeedbackPageState();
}

class _SubmitFeedbackPageState extends State<SubmitFeedbackPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thank you for your feedback!")),
      );

      nameController.clear();
      companyController.clear();
      positionController.clear();
      feedbackController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submit Feedback"), backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(  // ✅ Fix Overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📜 Header
            Text(
              "We value your feedback!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Please share your thoughts and experiences with us. Your feedback helps us improve our services!",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),

            // 📝 Feedback Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(nameController, "Your Name"),
                  const SizedBox(height: 15),
                  _buildTextField(companyController, "Company Name"),
                  const SizedBox(height: 15),
                  _buildTextField(positionController, "Your Position"),
                  const SizedBox(height: 15),
                  _buildTextField(feedbackController, "Your Feedback", isMultiline: true),
                  const SizedBox(height: 30),

                  // 🚀 Submit Button
                  ElevatedButton(
                    onPressed: _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Function to Build Text Fields
  Widget _buildTextField(TextEditingController controller, String label, {bool isMultiline = false}) {
    return TextFormField(
      controller: controller,
      maxLines: isMultiline ? 5 : 1,  // ✅ Fixed Height
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.blueGrey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
    );
  }
}
