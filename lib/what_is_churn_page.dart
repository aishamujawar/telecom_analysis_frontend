import 'package:flutter/material.dart';
import 'database_helper.dart';

class WhatIsChurnPage extends StatefulWidget {  // Rename from HomePage
  @override
  _WhatIsChurnPageState createState() => _WhatIsChurnPageState();
}

class _WhatIsChurnPageState extends State<WhatIsChurnPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Map<String, List<Map<String, dynamic>>> queryResults = {};

  final List<Map<String, String>> faqs = [
    {
      "question": "What is the overall churn rate?",
      "query":
          "SELECT (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers;"
    },
    {
      "question": "What is the churn rate by gender?",
      "query":
          "SELECT gender, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY gender;"
    },
    {
      "question": "What is the average tenure of churned vs non-churned customers?",
      "query":
          "SELECT Churn, AVG(tenure) AS avg_tenure FROM telcoCustomers GROUP BY Churn;"
    },
    {
      "question": "What is the average monthly charge for churned customers?",
      "query":
          "SELECT AVG(MonthlyCharges) AS avg_monthly_charge FROM telcoCustomers WHERE Churn = 'Yes';"
    },
    {
      "question": "What is the churn rate by contract type?",
      "query":
          "SELECT Contract, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY Contract;"
    },
    {
      "question": "What is the churn rate for customers with and without partners?",
      "query":
          "SELECT Partner, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY Partner;"
    },
    {
      "question": "What is the churn rate for customers with and without dependents?",
      "query":
          "SELECT Dependents, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY Dependents;"
    },
    {
      "question": "What is the churn rate by payment method?",
      "query":
          "SELECT PaymentMethod, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY PaymentMethod;"
    },
    {
      "question": "What is the churn rate for customers with online security?",
      "query":
          "SELECT OnlineSecurity, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY OnlineSecurity;"
    },
    {
      "question": "What is the churn rate for customers with tech support?",
      "query":
          "SELECT TechSupport, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY TechSupport;"
    },
    {
      "question": "What is the churn rate for customers with streaming TV?",
      "query":
          "SELECT StreamingTV, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY StreamingTV;"
    },
    {
      "question": "What is the churn rate for customers with streaming movies?",
      "query":
          "SELECT StreamingMovies, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY StreamingMovies;"
    },
    {
      "question": "What is the churn rate for customers with paperless billing?",
      "query":
          "SELECT PaperlessBilling, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY PaperlessBilling;"
    },
    {
      "question": "What is the churn rate for senior citizens?",
      "query":
          "SELECT SeniorCitizen, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY SeniorCitizen;"
    },
    {
      "question": "What is the average monthly charge for customers with and without online backup?",
      "query":
          "SELECT OnlineBackup, AVG(MonthlyCharges) AS avg_monthly_charge FROM telcoCustomers GROUP BY OnlineBackup;"
    },
    {
      "question": "What is the churn rate for customers with device protection?",
      "query":
          "SELECT DeviceProtection, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY DeviceProtection;"
    },
    {
      "question": "What is the churn rate for customers with multiple lines?",
      "query":
          "SELECT MultipleLines, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers GROUP BY MultipleLines;"
    },
    {
      "question": "What is the churn rate for customers with fiber optic internet?",
      "query":
          "SELECT InternetService, (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS churn_rate FROM telcoCustomers WHERE InternetService = 'Fiber optic' GROUP BY InternetService;"
    },
    {
      "question": "What is the total revenue lost due to churn?",
      "query":
          "SELECT SUM(MonthlyCharges) AS total_revenue_lost FROM telcoCustomers WHERE Churn = 'Yes';"
    },
    {
      "question": "What is the average monthly charge for customers with different internet services?",
      "query":
          "SELECT InternetService, AVG(MonthlyCharges) AS avg_monthly_charge FROM telcoCustomers GROUP BY InternetService;"
    },
    {
      "question": "What is the total number of customers by contract type?",
      "query":
          "SELECT Contract, COUNT(*) AS total_customers FROM telcoCustomers GROUP BY Contract;"
    },
    {
      "question": "What is the average tenure by internet service type?",
      "query":
          "SELECT InternetService, AVG(tenure) AS avg_tenure FROM telcoCustomers GROUP BY InternetService;"
    },
    {
      "question": "What is the total number of customers with and without tech support?",
      "query":
          "SELECT TechSupport, COUNT(*) AS total_customers FROM telcoCustomers GROUP BY TechSupport;"
    },
    {
      "question": "What is the average monthly charge for customers with different payment methods?",
      "query":
          "SELECT PaymentMethod, AVG(MonthlyCharges) AS avg_monthly_charge FROM telcoCustomers GROUP BY PaymentMethod;"
    },
  ];

  Future<void> executeQuery(String query) async {
    final result = await dbHelper.runQuery(query);
    setState(() {
      queryResults[query] = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telecom Churn Analysis'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Center(
                child: Text(
                  'Telecom Churn Analysis',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

              // Basic Information Section
              Card(
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What is Churn Rate?',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Churn rate is the percentage of subscribers who discontinue their subscriptions to a service within a given time period. It is a critical metric for telecom companies to monitor customer retention.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why is it Important?',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Understanding churn rate helps telecom companies identify issues, improve customer satisfaction, and develop strategies to retain customers. By analyzing churn patterns, businesses can proactively address customer concerns and enhance service quality.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // FAQ Section
              Text(
                'FAQs - Telecom Churn Insights',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  final query = faq['query']!;
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ExpansionTile(
                      title: Text(
                        faq['question']!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                      onExpansionChanged: (expanded) {
                        if (expanded && queryResults[query] == null) {
                          executeQuery(query);
                        }
                      },
                      iconColor: Colors.white,
                      children: [
                        queryResults[query] == null
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: queryResults[query]!.isEmpty
                                      ? [Text("No data found.", style: TextStyle(color: Colors.white))]
                                      : _formatQueryResults(queryResults[query]!, faq['question']!),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Format query results based on the question
  List<Widget> _formatQueryResults(List<Map<String, dynamic>> results, String question) {
    if (question.startsWith("What is the overall churn rate")) {
      return _formatSingleValue(results, "Overall Churn Rate", "%");
    } else if (question.startsWith("What is the churn rate by gender")) {
      return _formatGroupedResults(results, "gender", "churn_rate", "%");
    } else if (question.startsWith("What is the average tenure of churned vs non-churned customers")) {
      return _formatGroupedResults(results, "Churn", "avg_tenure", " months");
    } else if (question.startsWith("What is the average monthly charge for churned customers")) {
      return _formatSingleValue(results, "Average Monthly Charge for Churned Customers", "\$");
    } else if (question.startsWith("What is the churn rate by contract type")) {
      return _formatGroupedResults(results, "Contract", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate for customers with and without partners")) {
      return _formatGroupedResults(results, "Partner", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate for customers with and without dependents")) {
      return _formatGroupedResults(results, "Dependents", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate by payment method")) {
      return _formatGroupedResults(results, "PaymentMethod", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate for customers with online security")) {
      return _formatGroupedResults(results, "OnlineSecurity", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate for customers with tech support")) {
      return _formatGroupedResults(results, "TechSupport", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate for customers with streaming TV")) {
      return _formatGroupedResults(results, "StreamingTV", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate for customers with streaming movies")) {
      return _formatGroupedResults(results, "StreamingMovies", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate for customers with paperless billing")) {
      return _formatGroupedResults(results, "PaperlessBilling", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate for senior citizens")) {
      return _formatGroupedResults(results, "SeniorCitizen", "churn_rate", "%");
    } else if (question.startsWith("What is the average monthly charge for customers with and without online backup")) {
      return _formatGroupedResults(results, "OnlineBackup", "avg_monthly_charge", "\$");
    } else if (question.startsWith("What is the churn rate for customers with device protection")) {
      return _formatGroupedResults(results, "DeviceProtection", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate for customers with multiple lines")) {
      return _formatGroupedResults(results, "MultipleLines", "churn_rate", "%");
    } else if (question.startsWith("What is the churn rate for customers with fiber optic internet")) {
      return _formatGroupedResults(results, "InternetService", "churn_rate", "%");
    } else if (question.startsWith("What is the total revenue lost due to churn")) {
      return _formatSingleValue(results, "Total Revenue Lost Due to Churn", "\$");
    } else if (question.startsWith("What is the average monthly charge for customers with different internet services")) {
      return _formatGroupedResults(results, "InternetService", "avg_monthly_charge", "\$");
    } else if (question.startsWith("What is the total number of customers by contract type")) {
      return _formatGroupedResults(results, "Contract", "total_customers", "");
    } else if (question.startsWith("What is the average tenure by internet service type")) {
      return _formatGroupedResults(results, "InternetService", "avg_tenure", " months");
    } else if (question.startsWith("What is the total number of customers with and without tech support")) {
      return _formatGroupedResults(results, "TechSupport", "total_customers", "");
    } else if (question.startsWith("What is the average monthly charge for customers with different payment methods")) {
      return _formatGroupedResults(results, "PaymentMethod", "avg_monthly_charge", "\$");
    } else {
      return results.map<Widget>((row) => _buildAnswerRow(row)).toList();
    }
  }

  // Format single value results with a suffix (e.g., %, $)
  List<Widget> _formatSingleValue(List<Map<String, dynamic>> results, String label, String suffix) {
    final value = results[0].values.first;
    final formattedValue = value is double ? value.toStringAsFixed
        (2) : value.toString();
    return [
      Text(
        '$label: $formattedValue$suffix',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ];
  }

  // Format grouped results with a suffix (e.g., %, $)
  List<Widget> _formatGroupedResults(List<Map<String, dynamic>> results, String groupBy, String valueKey, String suffix) {
    return results.map<Widget>((row) {
      final value = row[valueKey];
      final formattedValue = value is double ? value.toStringAsFixed(2) : value.toString();
      return Text(
        '${row[groupBy]}: $formattedValue$suffix',
        style: TextStyle(color: Colors.white, fontSize: 16),
      );
    }).toList();
  }

  // Build a single answer row
  Widget _buildAnswerRow(Map<String, dynamic> row) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: row.entries.map<Widget>((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '${entry.key}: ${entry.value}',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }).toList(),
    );
  }
}
