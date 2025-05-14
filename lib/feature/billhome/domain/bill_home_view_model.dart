import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:split_bill/core/repositories/database_service.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/debt_model.dart';
import 'package:split_bill/entities/group_table_model.dart';
import 'package:split_bill/entities/result/delete_group_result.dart';
import 'package:split_bill/entities/result/update_group_result.dart';

part 'bill_home_view_model.g.dart';

class BillHomeState {
  final List<GroupTableModel>? groupTables;
  final int? selectedTableId;
  final List<BillModel>? bills;
  final List<DebtModel>? debts;

  BillHomeState({
    this.groupTables,
    this.selectedTableId,
    this.bills,
    this.debts,
  });

  BillHomeState copyWith({
    List<GroupTableModel>? groupTables,
    int? selectedTableId,
    List<BillModel>? bills,
    List<DebtModel>? debts,
  }) {
    return BillHomeState(
      groupTables: groupTables ?? this.groupTables,
      selectedTableId: selectedTableId ?? this.selectedTableId,
      bills: bills ?? this.bills,
      debts: debts ?? this.debts,
    );
  }
}

@riverpod
class BillHomeViewModel extends _$BillHomeViewModel {
  @override
  FutureOr<BillHomeState> build() async {
    return await initData();
  }

  Future<BillHomeState> initData() async {
    final dbService = ref.read(databaseServiceProvider.notifier);
    final tableList = await dbService.getTables();
    final allBills = await dbService.getBills();

    if (tableList.isEmpty) {
      return BillHomeState(groupTables: tableList);
    }

    final currentTableId = state.value?.selectedTableId ?? tableList[0].id;
    final filteredBills =
        allBills.where((e) => e.tableId == currentTableId).toList();

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

      for (var participant in participants) {
        if (participant != paidBy) {
          balances[participant] = (balances[participant] ?? 0) - splitAmount;
        }
      }
    }

    List<DebtModel> debts = [];

    balances.forEach((debtor, amount) {
      if (amount < 0) {
        balances.forEach((creditor, value) {
          if (value > 0) {
            double toPay = amount.abs();
            double payment = value >= toPay ? toPay : value;
            debts.add(
                DebtModel(debtor: debtor, creditor: creditor, amount: payment));
            balances[creditor] = value - payment;
            balances[debtor] = 0;
          }
        });
      }
    });

    debts.forEach((debt) {
      debugPrint(
          '${debt.debtor} 欠 ${debt.creditor} ${debt.amount.toStringAsFixed(2)} 元');
    });

    return BillHomeState(
      groupTables: tableList,
      selectedTableId: currentTableId,
      bills: billsWithSettledBy,
      debts: debts,
    );
  }

  Future<UpdateGroupResult> updateGroupName(String newTitle, int id) async {
    try {
      final dbService = ref.read(databaseServiceProvider.notifier);
      await dbService.updateTableTitle(id, newTitle);
      state = await AsyncValue.guard(() => initData());
      return UpdateGroupResult(isSuccess: true);
    } catch (e) {
      return UpdateGroupResult(isSuccess: false, errorMessage: "$e");
    }
  }

  Future<void> changeGroup(int id) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(selectedTableId: id));
    state = await AsyncValue.guard(() => initData());
  }

  Future<DeleteGroupResult> deleteGroup(int id) async {
    try {
      final dbService = ref.read(databaseServiceProvider.notifier);
      await dbService.deleteTable(id);
      state = AsyncValue.data(state.value!.copyWith(selectedTableId: null));
      state = await AsyncValue.guard(() => initData());
      return DeleteGroupResult(isSuccess: true);
    } catch (e) {
      return DeleteGroupResult(isSuccess: false, errorMessage: "$e");
    }
  }
}
