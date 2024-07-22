import 'package:flutter/material.dart';
import 'package:split_bill/core/database/database_helper.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/group_table_model.dart';

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
    await db.transaction((txn) async {
      int billId = await txn.insert('Bill', bill.toMap());
      for (String settle in bill.settledBy) {
        await txn.insert('BillSettledBy', {
          'billId': billId,
          'settledBy': settle,
        });
      }
    });
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

  Future<void> deleteTable(int tableId) async {
    // final db = await _dbHelper.database;
    // await db.delete(
    //   'GroupTable',
    //   where: 'id = ?',
    //   whereArgs: [tableId],
    // );
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      // 获取与该 table 相关的 bill 记录
      final List<Map<String, dynamic>> billMaps = await txn.query(
        'Bill',
        where: 'tableId = ?',
        whereArgs: [tableId],
      );

      for (var bill in billMaps) {
        int billId = bill['id'] as int;

        // 删除与该 bill 相关的 BillSettledBy 记录
        await txn.delete(
          'BillSettledBy',
          where: 'billId = ?',
          whereArgs: [billId],
        );

        // 删除 Bill 记录
        await txn.delete(
          'Bill',
          where: 'id = ?',
          whereArgs: [billId],
        );
      }

      // 删除 GroupTable 中的记录
      await txn.delete(
        'GroupTable',
        where: 'id = ?',
        whereArgs: [tableId],
      );
    });
  }

  Future<void> updateTableTitle(int tableId, String newTitle) async {
    final db = await _dbHelper.database;
    await db.update(
      'GroupTable',
      {'name': newTitle},
      where: 'id = ?',
      whereArgs: [tableId],
    );
  }

  Future<void> updateBill(BillModel bill) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      int count = await txn.update(
        'Bill',
        bill.toMap(),
        where: 'id = ?',
        whereArgs: [bill.id],
      );
      if (count == 0) {
        throw Exception('Failed to update Bill');
      }

      int deletedCount = await txn.delete(
        'BillSettledBy',
        where: 'billId = ?',
        whereArgs: [bill.id],
      );
      debugPrint('Deleted $deletedCount records from BillSettledBy for billId ${bill.id}');

      for (String settle in bill.settledBy) {
        int insertedId = await txn.insert('BillSettledBy', {
          'billId': bill.id,
          'settledBy': settle,
        });
        if (insertedId == 0) {
          throw Exception('Failed to insert into BillSettledBy');
        }
      }
    });
  }
}
