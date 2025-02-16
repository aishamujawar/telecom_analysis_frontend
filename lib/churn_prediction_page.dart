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
  double confidence = 0.0; // Add confidence rate

  Future<void> _predictChurn() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse('http://10.118.52.240:5001/predict'); // Your local IP
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "tenure": int.parse(tenureController.text),
        "MonthlyCharges": double.parse(monthlyChargesController.text),
        "TotalCharges": double.parse(totalChargesController.text),
        "Contract": int.parse(contractController.text), // 0=Month-to-Month, 1=One Year, 2=Two Years
        "PaymentMethod": int.parse(paymentMethodController.text), // 0=Bank, 1=Credit Card, 2=Electronic
        "SeniorCitizen": int.parse(seniorCitizenController.text), // 0=No, 1=Yes
        "gender": int.parse(genderController.text), // 0=Female, 1=Male
        "Partner": int.parse(partnerController.text), // 0=No, 1=Yes
        "Dependents": int.parse(dependentsController.text), // 0=No, 1=Yes
        "PhoneService": int.parse(phoneServiceController.text), // 0=No, 1=Yes
        "MultipleLines": int.parse(multipleLinesController.text), // 0=No, 1=Yes
        "InternetService": int.parse(internetServiceController.text), // 0=DSL, 1=Fiber optic
        "OnlineSecurity": int.parse(onlineSecurityController.text), // 0=No, 1=Yes
        "OnlineBackup": int.parse(onlineBackupController.text), // 0=No, 1=Yes
        "DeviceProtection": int.parse(deviceProtectionController.text), // 0=No, 1=Yes
        "TechSupport": int.parse(techSupportController.text), // 0=No, 1=Yes
        "StreamingTV": int.parse(streamingTVController.text), // 0=No, 1=Yes
        "StreamingMovies": int.parse(streamingMoviesController.text), // 0=No, 1=Yes
        "PaperlessBilling": int.parse(paperlessBillingController.text) // 0=No, 1=Yes
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        result = jsonResponse['prediction'] == 1
            ? "⚠️ High Churn Risk!"
            : "✅ Customer is Safe!";
        confidence = jsonResponse['probability']; // Set confidence rate
      });
    } else {
      setState(() {
        result = "Error: Could not get prediction.";
        confidence = 0.0; // Reset confidence rate on error
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Row 1
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField(tenureController, "Tenure (months)", "1-72", (value) {
                            if (value == null || value.isEmpty) return "Enter Tenure";
                            final tenure = int.tryParse(value);
                            if (tenure == null || tenure < 1 || tenure > 72) {
                              return "Enter a value between 1 and 72";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(monthlyChargesController, "Monthly Charges", "10-120", (value) {
                            if (value == null || value.isEmpty) return "Enter Monthly Charges";
                            final monthlyCharges = double.tryParse(value);
                            if (monthlyCharges == null || monthlyCharges < 10 || monthlyCharges > 120) {
                              return "Enter a value between 10 and 120";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(totalChargesController, "Total Charges", "0-8000", (value) {
                            if (value == null || value.isEmpty) return "Enter Total Charges";
                            final totalCharges = double.tryParse(value);
                            if (totalCharges == null || totalCharges < 0 || totalCharges > 8000) {
                              return "Enter a value between 0 and 8000";
                            }
                            return null;
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10), // Consistent spacing between columns
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField(contractController, "Contract Type", "0=Month-to-Month, 1=One Year, 2=Two Years", (value) {
                            if (value == null || value.isEmpty) return "Enter Contract Type";
                            final contract = int.tryParse(value);
                            if (contract == null || contract < 0 || contract > 2) {
                              return "Enter 0, 1, or 2";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(paymentMethodController, "Payment Method", "0=Bank, 1=Credit Card, 2=Electronic", (value) {
                            if (value == null || value.isEmpty) return "Enter Payment Method";
                            final paymentMethod = int.tryParse(value);
                            if (paymentMethod == null || paymentMethod < 0 || paymentMethod > 2) {
                              return "Enter 0, 1, or 2";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(seniorCitizenController, "Senior Citizen", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Senior Citizen";
                            final seniorCitizen = int.tryParse(value);
                            if (seniorCitizen == null || seniorCitizen < 0 || seniorCitizen > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10), // Consistent spacing between columns
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField(genderController, "Gender", "0=Female, 1=Male", (value) {
                            if (value == null || value.isEmpty) return "Enter Gender";
                            final gender = int.tryParse(value);
                            if (gender == null || gender < 0 || gender > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(partnerController, "Partner", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Partner";
                            final partner = int.tryParse(value);
                            if (partner == null || partner < 0 || partner > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(dependentsController, "Dependents", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Dependents";
                            final dependents = int.tryParse(value);
                            if (dependents == null || dependents < 0 || dependents > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10), // Consistent spacing between columns
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField(phoneServiceController, "Phone Service", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Phone Service";
                            final phoneService = int.tryParse(value);
                            if (phoneService == null || phoneService < 0 || phoneService > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(multipleLinesController, "Multiple Lines", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Multiple Lines";
                            final multipleLines = int.tryParse(value);
                            if (multipleLines == null || multipleLines < 0 || multipleLines > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(internetServiceController, "Internet Service", "0=DSL, 1=Fiber optic", (value) {
                            if (value == null || value.isEmpty) return "Enter Internet Service";
                            final internetService = int.tryParse(value);
                            if (internetService == null || internetService < 0 || internetService > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Consistent spacing between rows
                // Row 2
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField(onlineSecurityController, "Online Security", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Online Security";
                            final onlineSecurity = int.tryParse(value);
                            if (onlineSecurity == null || onlineSecurity < 0 || onlineSecurity > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(onlineBackupController, "Online Backup", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Online Backup";
                            final onlineBackup = int.tryParse(value);
                            if (onlineBackup == null || onlineBackup < 0 || onlineBackup > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10), // Consistent spacing between columns
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField(deviceProtectionController, "Device Protection", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Device Protection";
                            final deviceProtection = int.tryParse(value);
                            if (deviceProtection == null || deviceProtection < 0 || deviceProtection > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(techSupportController, "Tech Support", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Tech Support";
                            final techSupport = int.tryParse(value);
                            if (techSupport == null || techSupport < 0 || techSupport > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10), // Consistent spacing between columns
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField(streamingTVController, "Streaming TV", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Streaming TV";
                            final streamingTV = int.tryParse(value);
                            if (streamingTV == null || streamingTV < 0 || streamingTV > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                          const SizedBox(height: 10), // Consistent spacing
                          _buildTextField(streamingMoviesController, "Streaming Movies", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Streaming Movies";
                            final streamingMovies = int.tryParse(value);
                            if (streamingMovies == null || streamingMovies < 0 || streamingMovies > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10), // Consistent spacing between columns
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField(paperlessBillingController, "Paperless Billing", "0=No, 1=Yes", (value) {
                            if (value == null || value.isEmpty) return "Enter Paperless Billing";
                            final paperlessBilling = int.tryParse(value);
                            if (paperlessBilling == null || paperlessBilling < 0 || paperlessBilling > 1) {
                              return "Enter 0 or 1";
                            }
                            return null;
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Consistent spacing before the button
                ElevatedButton(
                  onPressed: _predictChurn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Predict Churn"),
                ),
                const SizedBox(height: 20), // Consistent spacing after the button
                Text(
                  result,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                if (confidence > 0) // Conditionally display confidence
                  Column(
                    children: [
                      const SizedBox(height: 10), // Spacing between result and confidence
                      Text(
                        "Confidence: ${(confidence * 100).toStringAsFixed(2)}%", // Display confidence rate
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, FormFieldValidator<String> validator) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      validator: validator,
    );
  }
}