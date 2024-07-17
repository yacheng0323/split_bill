import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    await Directory(dbPath).create(recursive: true);


    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE GroupTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Bill (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        dateTime INTEGER NOT NULL,
        money REAL NOT NULL,
        paidBy TEXT NOT NULL,
        tableId INTEGER,
        FOREIGN KEY (tableId) REFERENCES GroupTable(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE TableMembers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tableId INTEGER,
        member TEXT NOT NULL,
        FOREIGN KEY (tableId) REFERENCES GroupTable(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE BillSettledBy (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        billId INTEGER,
        settledBy TEXT NOT NULL,
        FOREIGN KEY (billId) REFERENCES Bill(id) ON DELETE CASCADE
      )
    ''');
  }
}
