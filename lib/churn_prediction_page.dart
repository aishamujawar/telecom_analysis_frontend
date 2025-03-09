import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChurnPredictionPage extends StatefulWidget {
  @override
  _ChurnPredictionPageState createState() => _ChurnPredictionPageState();
}

class _ChurnPredictionPageState extends State<ChurnPredictionPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for user input
  final TextEditingController tenureController = TextEditingController();
  final TextEditingController monthlyChargesController = TextEditingController();
  final TextEditingController totalChargesController = TextEditingController();
  final TextEditingController contractController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController seniorCitizenController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController partnerController = TextEditingController();
  final TextEditingController dependentsController = TextEditingController();
  final TextEditingController phoneServiceController = TextEditingController();
  final TextEditingController multipleLinesController = TextEditingController();
  final TextEditingController internetServiceController = TextEditingController();
  final TextEditingController onlineSecurityController = TextEditingController();
  final TextEditingController onlineBackupController = TextEditingController();
  final TextEditingController deviceProtectionController = TextEditingController();
  final TextEditingController techSupportController = TextEditingController();
  final TextEditingController streamingTVController = TextEditingController();
  final TextEditingController streamingMoviesController = TextEditingController();
  final TextEditingController paperlessBillingController = TextEditingController();

  String result = "";
  double confidence = 0.0; // Confidence rate

  Future<void> _predictChurn() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse('http://127.0.0.1:5001/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "tenure": int.parse(tenureController.text),
        "MonthlyCharges": double.parse(monthlyChargesController.text),
        "TotalCharges": double.parse(totalChargesController.text),
        "Contract": int.parse(contractController.text),
        "PaymentMethod": int.parse(paymentMethodController.text),
        "SeniorCitizen": int.parse(seniorCitizenController.text),
        "gender": int.parse(genderController.text),
        "Partner": int.parse(partnerController.text),
        "Dependents": int.parse(dependentsController.text),
        "PhoneService": int.parse(phoneServiceController.text),
        "MultipleLines": int.parse(multipleLinesController.text),
        "InternetService": int.parse(internetServiceController.text),
        "OnlineSecurity": int.parse(onlineSecurityController.text),
        "OnlineBackup": int.parse(onlineBackupController.text),
        "DeviceProtection": int.parse(deviceProtectionController.text),
        "TechSupport": int.parse(techSupportController.text),
        "StreamingTV": int.parse(streamingTVController.text),
        "StreamingMovies": int.parse(streamingMoviesController.text),
        "PaperlessBilling": int.parse(paperlessBillingController.text)
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        result = jsonResponse['prediction'] == 1
            ? "⚠️ High Churn Risk!"
            : "✅ Customer is Safe!";
        confidence = jsonResponse['probability'];
      });
    } else {
      setState(() {
        result = "Error: Could not get prediction.";
        confidence = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Churn Predictor", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  "Predict Customer Churn",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),

                // Description
                Text(
                  "Fill in the customer details to predict churn risk.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Form Fields
                _buildTextField(tenureController, "Tenure (months)", "1-72"),
                _buildTextField(monthlyChargesController, "Monthly Charges", "10-120"),
                _buildTextField(totalChargesController, "Total Charges", "0-8000"),
                _buildTextField(contractController, "Contract Type", "0=Month-to-Month, 1=One Year, 2=Two Years"),
                _buildTextField(paymentMethodController, "Payment Method", "0=Bank, 1=Credit Card, 2=Electronic"),
                _buildTextField(seniorCitizenController, "Senior Citizen", "0=No, 1=Yes"),
                _buildTextField(genderController, "Gender", "0=Female, 1=Male"),
                _buildTextField(partnerController, "Partner", "0=No, 1=Yes"),
                _buildTextField(dependentsController, "Dependents", "0=No, 1=Yes"),
                _buildTextField(phoneServiceController, "Phone Service", "0=No, 1=Yes"),
                _buildTextField(multipleLinesController, "Multiple Lines", "0=No, 1=Yes"),
                _buildTextField(internetServiceController, "Internet Service", "0=DSL, 1=Fiber optic"),
                _buildTextField(onlineSecurityController, "Online Security", "0=No, 1=Yes"),
                _buildTextField(onlineBackupController, "Online Backup", "0=No, 1=Yes"),
                _buildTextField(deviceProtectionController, "Device Protection", "0=No, 1=Yes"),
                _buildTextField(techSupportController, "Tech Support", "0=No, 1=Yes"),
                _buildTextField(streamingTVController, "Streaming TV", "0=No, 1=Yes"),
                _buildTextField(streamingMoviesController, "Streaming Movies", "0=No, 1=Yes"),
                _buildTextField(paperlessBillingController, "Paperless Billing", "0=No, 1=Yes"),
                
                const SizedBox(height: 20),

                // Predict Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _predictChurn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Predict Churn"),
                  ),
                ),

                const SizedBox(height: 20),

                // Prediction Result
                Text(
                  result,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),

                if (confidence > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Confidence: ${(confidence * 100).toStringAsFixed(2)}%",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[900],
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
