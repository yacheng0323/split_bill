import 'package:split_bill/database/database_helper.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/group_table_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertTable(GroupTableModel table) async {
    final db = await _dbHelper.database;
    await db.insert('GroupTable', table.toMap());
  }

  Future<List<GroupTableModel>> getTables() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('GroupTable');

    return List.generate(maps.length, (i) {
      return GroupTableModel.fromMap(maps[i]);
    });
  }

  Future<void> insertBill(BillModel bill) async {
    final db = await _dbHelper.database;
    await db.insert('Bill', bill.toMap());
  }

  Future<List<BillModel>> getBills() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Bill');

    return List.generate(maps.length, (i) {
      return BillModel.fromMap(maps[i]);
    });
  }
}
