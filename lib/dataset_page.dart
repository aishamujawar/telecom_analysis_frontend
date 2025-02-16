import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart'; // For loading assets

class DatasetPage extends StatefulWidget {
  @override
  _DatasetPageState createState() => _DatasetPageState();
}

class _DatasetPageState extends State<DatasetPage> {
  List<List<dynamic>> _csvData = [];
  List<List<dynamic>> _displayedData = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _rowsToShow = 100; // Number of rows to display at a time

  @override
  void initState() {
    super.initState();
    _loadCsvFromAssets();
  }

  Future<void> _loadCsvFromAssets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Load the CSV file from the assets
      final input = await rootBundle.loadString('assets/Telecom-Customer-Churn.csv');
      // Parse the entire CSV data
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(input);

      setState(() {
        _csvData = csvTable;
        _displayedData = csvTable.take(_rowsToShow).toList(); // Display first 100 rows
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading CSV file: $e";
      });
      print(_errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadMoreRows() {
    setState(() {
      _rowsToShow += 100; // Increase the number of rows to show
      _displayedData = _csvData.take(_rowsToShow).toList(); // Update displayed data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dataset', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "This is the dataset we're basing our analysis on.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.white)))
                    : Container(
                        margin: const EdgeInsets.all(16.0), // Add margins around the container
                        decoration: BoxDecoration(
                          color: Colors.grey[900], // Background color for the container
                          borderRadius: BorderRadius.circular(8.0), // Optional: Add rounded corners
                        ),
                        padding: const EdgeInsets.all(16.0), // Padding inside the container
                        child: Column(
                          children: [
                            // Sticky Header Row with Horizontal Scroll
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                              child: Container(
                                color: Colors.grey[800], // Header background color
                                child: DataTable(
                                  columns: _displayedData.first
                                      .map((column) => DataColumn(
                                            label: Text(
                                              column.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ))
                                      .toList(),
                                  rows: const [], // Empty rows for the header
                                ),
                              ),
                            ),
                            // Scrollable Data Rows
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical, // Vertical scrolling
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal, // Horizontal scrolling
                                  child: DataTable(
                                    columns: _displayedData.first
                                        .map((column) => DataColumn(
                                              label: Text(
                                                column.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ))
                                        .toList(),
                                    rows: _displayedData
                                        .skip(1) // Skip the header row
                                        .map((row) => DataRow(
                                              cells: row
                                                  .map((cell) => DataCell(
                                                        Text(
                                                          cell.toString(),
                                                          style: const TextStyle(color: Colors.white),
                                                        ),
                                                      ))
                                                  .toList(),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            if (_displayedData.length < _csvData.length)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: ElevatedButton(
                                  onPressed: _loadMoreRows,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text("Load More Rows"),
                                ),
                              ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}