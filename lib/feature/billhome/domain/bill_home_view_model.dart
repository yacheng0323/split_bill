import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:split_bill/core/database/database_service.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/debt_model.dart';
import 'package:split_bill/entities/group_table_model.dart';
import 'package:split_bill/entities/result/delete_group_result.dart';
import 'package:split_bill/entities/result/update_group_result.dart';

class BillHomeViewModel {
  final _groupTables = BehaviorSubject<List<GroupTableModel>?>.seeded(null);

  ValueStream<List<GroupTableModel>?> get groupTables => _groupTables.stream;

  final _tableId = BehaviorSubject<int?>.seeded(null);

  int? get tableId => _tableId.value;

  final _billList = BehaviorSubject<List<BillModel>?>.seeded(null);

  ValueStream<List<BillModel>?> get billList => _billList.stream;

  final _debtList = BehaviorSubject<List<DebtModel>?>.seeded(null);

  ValueStream<List<DebtModel>?> get debtList => _debtList.stream;

  Future<void> initData() async {
    final dbService = GetIt.I.get<DatabaseService>();
    final tableList = await dbService.getTables();
    final allBills = await dbService.getBills();

    if (tableList.isEmpty) {
      _groupTables.add(tableList);
      return;
    }
    final currentTableId = _tableId.value ?? tableList[0].id;
    _tableId.add(currentTableId);
    _groupTables.add(tableList);

    final filteredBills = allBills.where((e) => e.tableId == tableId).toList();

    final List<Future<BillModel>> futureBills = filteredBills.map((item) async {
      final settledByMaps = await dbService.getBillSettledBy(item.id ?? 0);
      return BillModel(
        id: item.id,
        title: item.title,
        dateTime: item.dateTime,
        money: item.money,
        paidBy: item.paidBy,
        tableId: item.tableId,
        settledBy: settledByMaps,
      );
    }).toList();

    final List<BillModel> billsWithSettledBy = await Future.wait(futureBills);
    final Map<String, double> balances = {};

    for (var bill in billsWithSettledBy) {
      String paidBy = bill.paidBy;
      List<String> participants = bill.settledBy;
      double splitAmount = bill.money / participants.length;

      balances[paidBy] = (balances[paidBy] ?? 0) + (bill.money - splitAmount);

      participants.forEach((participant) {
        if (participant != paidBy) {
          balances[participant] = (balances[participant] ?? 0) - splitAmount;
        }
      });
    }

    List<DebtModel> debts = [];

    balances.forEach((debtor, amount) {
      if (amount < 0) {
        balances.forEach((creditor, value) {
          if (value > 0) {
            double toPay = amount.abs();
            double payment = value >= toPay ? toPay : value;
            debts.add(DebtModel(debtor: debtor, creditor: creditor, amount: payment));
            balances[creditor] = value - payment;
            balances[debtor] = 0;
          }
        });
      }
    });

    debts.forEach((debt) {
      debugPrint('${debt.debtor} 欠 ${debt.creditor} ${debt.amount} 元');
    });

    _billList.add(billsWithSettledBy);
    _debtList.add(debts);
  }

  Future<UpdateGroupResult> updateGroupName(String newTitle, int id) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      await dbService.updateTableTitle(id, newTitle);
      await initData();
      return UpdateGroupResult(isSuccess: true);
    } catch (e) {
      return UpdateGroupResult(isSuccess: false, errorMessage: "$e");
    }
  }

  Future<void> changeGroup(int id) async {
    _tableId.add(id);
    await initData();
  }

  Future<DeleteGroupResult> deleteGroup(int id) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      await dbService.deleteTable(id);
      _tableId.add(null);
      await initData();
      return DeleteGroupResult(isSuccess: true);
    } catch (e) {
      return DeleteGroupResult(isSuccess: false, errorMessage: "$e");
    }
  }
}
