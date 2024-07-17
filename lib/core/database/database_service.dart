import 'package:split_bill/core/database/database_helper.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/group_table_model.dart';
import 'package:split_bill/entities/insert_member_result.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> createTableAndReturnId(GroupTableModel table) async {
    final db = await _dbHelper.database;
    return await db.insert('GroupTable', table.toMap());
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

  Future<void> insertTableMembers(int tableId, List<String> members) async {
    final db = await _dbHelper.database;
    for (String member in members) {
      await db.insert('TableMembers', {
        'tableId': tableId,
        'member': member,
      });
    }
  }

  Future<List<String>> getTableMembers(int tableId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'TableMembers',
      where: 'tableId = ?',
      whereArgs: [tableId],
    );

    return List.generate(maps.length, (i) {
      return maps[i]['member'] as String;
    });
  }

  Future<void> insertBillSettledBy(int billId, String settledBy) async {
    final db = await _dbHelper.database;
    await db.insert('BillSettledBy', {
      'billId': billId,
      'settledBy': settledBy,
    });
  }

  Future<List<String>> getBillSettledBy(int billId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'BillSettledBy',
      where: 'billId = ?',
      whereArgs: [billId],
    );

    return List.generate(maps.length, (i) {
      return maps[i]['settledBy'] as String;
    });
  }

  // Future<> fetchById()
}
