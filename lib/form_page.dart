import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _uploadedFileName;

  void _pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _uploadedFileName = result.files.single.name;
      });
    }
  }

  void _submitForm(BuildContext context) {
    if (_companyController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Form Submitted Successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request a Service")),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85, // Centered compact layout
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Text(
                  "Request a Telecom Data Analysis Service",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Fill out the form below to schedule a consultation and upload any necessary datasets for analysis.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                SizedBox(height: 20),

                // Input Fields
                _buildTextField("Company Name", _companyController),
                _buildTextField("Your Name", _nameController),
                _buildTextField("Email", _emailController),
                _buildTextField("Phone Number", _phoneController),
                _buildTextField("Location", _locationController),

                // Date & Time Picker
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? "Select Consultation Date & Time"
                        : "Scheduled: ${_selectedDate!.toLocal()} at ${_selectedTime!.format(context)}",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(Icons.calendar_today, color: Colors.blue),
                  onTap: () => _pickDateTime(context),
                ),

                // Dataset Upload
                ListTile(
                  title: Text(
                    _uploadedFileName ?? "Upload Dataset (Optional)",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(Icons.upload_file, color: Colors.blue),
                  onTap: _pickFile,
                ),

                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: Text("Submit Request"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.blueGrey[800],
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
