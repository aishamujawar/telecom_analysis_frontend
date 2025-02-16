import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'telecom_churn.db');

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS telcoCustomers (
            customerID TEXT PRIMARY KEY,
            gender TEXT,
            SeniorCitizen INTEGER,
            Partner TEXT,
            Dependents TEXT,
            tenure INTEGER,
            PhoneService TEXT,
            MultipleLines TEXT,
            InternetService TEXT,
            OnlineSecurity TEXT,
            OnlineBackup TEXT,
            DeviceProtection TEXT,
            TechSupport TEXT,
            StreamingTV TEXT,
            StreamingMovies TEXT,
            Contract TEXT,
            PaperlessBilling TEXT,
            PaymentMethod TEXT,
            MonthlyCharges REAL,
            TotalCharges TEXT,
            Churn TEXT
          )
        ''');
      },
    );

    // Check if data exists; if not, insert from CSV
    var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM telcoCustomers'));
    if (count == 0) {
      await _insertCsvData(db);
    }

    return db;
  }

  // Load CSV and insert data
  Future<void> _insertCsvData(Database db) async {
    String csvData = await rootBundle.loadString('assets/Telecom-Customer-Churn.csv');
    List<String> rows = LineSplitter.split(csvData).toList();
    List<String> headers = rows[0].split(',');

    for (int i = 1; i < rows.length; i++) {
      List<String> values = rows[i].split(',');

      Map<String, dynamic> rowData = {};
      for (int j = 0; j < headers.length; j++) {
        rowData[headers[j]] = values[j];
      }

      await db.insert('telcoCustomers', rowData, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Execute SQL queries dynamically
  Future<List<Map<String, dynamic>>> runQuery(String query) async {
    final db = await database;
    return await db.rawQuery(query);
  }
}