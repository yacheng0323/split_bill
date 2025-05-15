import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:split_bill/core/providers/database_provider.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/group_table_model.dart';
import 'package:sqflite/sqflite.dart';

part 'database_service.g.dart';

@Riverpod(keepAlive: true)
class DatabaseService extends _$DatabaseService {
  @override
  Future<Database> build() async {
    try {
      final db = await ref.watch(databaseProviderProvider.future);
      state = AsyncValue.data(db);
      return db;
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  Future<int> createTableAndReturnId(GroupTableModel table) async {
    final db = await _getDatabase();
    return await db.insert('GroupTable', table.toMap());
  }

  Future<List<GroupTableModel>> getTables() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('GroupTable');

    return List.generate(maps.length, (i) {
      return GroupTableModel.fromMap(maps[i]);
    });
  }

  Future<void> insertBill(BillModel bill) async {
    final db = await _getDatabase();
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
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('Bill');

    return List.generate(maps.length, (i) {
      return BillModel.fromMap(maps[i]);
    });
  }

  Future<void> insertTableMembers(int tableId, List<String> members) async {
    final db = await _getDatabase();
    for (String member in members) {
      await db.insert('TableMembers', {
        'tableId': tableId,
        'member': member,
      });
    }
  }

  Future<List<String>> getTableMembers(int tableId) async {
    final db = await _getDatabase();
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
    final db = await _getDatabase();
    await db.insert('BillSettledBy', {
      'billId': billId,
      'settledBy': settledBy,
    });
  }

  Future<List<String>> getBillSettledBy(int billId) async {
    final db = await _getDatabase();
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
    final db = await _getDatabase();
    await db.transaction((txn) async {
      final List<Map<String, dynamic>> billMaps = await txn.query(
        'Bill',
        where: 'tableId = ?',
        whereArgs: [tableId],
      );

      for (var bill in billMaps) {
        int billId = bill['id'] as int;

        await txn.delete(
          'BillSettledBy',
          where: 'billId = ?',
          whereArgs: [billId],
        );

        await txn.delete(
          'Bill',
          where: 'id = ?',
          whereArgs: [billId],
        );
      }

      await txn.delete(
        'GroupTable',
        where: 'id = ?',
        whereArgs: [tableId],
      );
    });
  }

  Future<void> updateTableTitle(int tableId, String newTitle) async {
    final db = await _getDatabase();
    await db.update(
      'GroupTable',
      {'name': newTitle},
      where: 'id = ?',
      whereArgs: [tableId],
    );
  }

  Future<void> updateBill(BillModel bill) async {
    final db = await _getDatabase();
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
      debugPrint(
          'Deleted $deletedCount records from BillSettledBy for billId ${bill.id}');

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

  Future<Database> _getDatabase() async {
    try {
      if (!state.hasValue || state.value == null) {
        // 重新初始化資料庫
        final db = await build();
        return db;
      }
      return state.value!;
    } catch (e) {
      throw Exception('Database connection failed: $e');
    }
  }
}
