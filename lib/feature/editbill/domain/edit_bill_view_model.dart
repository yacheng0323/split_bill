import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:split_bill/core/repositories/database_service.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/result/edit_bill_result.dart';

part 'edit_bill_view_model.g.dart';

class EditBillState {
  final List<String>? members;
  final List<String>? settledMembers;
  final DateTime? dateTime;

  EditBillState({
    this.members,
    this.settledMembers,
    this.dateTime,
  });

  EditBillState copyWith({
    List<String>? members,
    List<String>? settledMembers,
    DateTime? dateTime,
  }) {
    return EditBillState(
      members: members ?? this.members,
      settledMembers: settledMembers ?? this.settledMembers,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

@riverpod
class EditBillViewModel extends _$EditBillViewModel {
  @override
  Future<EditBillState> build() async {
    return EditBillState();
  }

  Future<void> init(int tableId, List<String> settledMembers) async {
    try {
      final dbService = ref.read(databaseServiceProvider.notifier);
      final List<String> memberList = await dbService.getTableMembers(tableId);
      state = AsyncValue.data(state.value!
          .copyWith(members: memberList, settledMembers: settledMembers));
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  void toggleMember(String name) async {
    final list = state.value!.settledMembers ?? [];
    if (list.contains(name)) {
      list.remove(name);
    } else {
      list.add(name);
    }
    state = AsyncValue.data(state.value!.copyWith(settledMembers: list));
  }

  void setDateTime(DateTime date) {
    state = AsyncValue.data(state.value!.copyWith(dateTime: date));
  }

  Future<EditBillResult> updateBill(
    int billid,
    int tableId,
    String title,
    double money,
    String paidBy,
  ) async {
    try {
      final dbService = ref.read(databaseServiceProvider.notifier);
      BillModel bill = BillModel(
        id: billid,
        tableId: tableId,
        title: title,
        dateTime: state.value!.dateTime!.millisecondsSinceEpoch ~/ 1000,
        money: money,
        paidBy: paidBy,
        settledBy: state.value!.settledMembers ?? [],
      );
      await dbService.updateBill(bill);
      return EditBillResult(isSuccess: true);
    } catch (e) {
      return EditBillResult(isSuccess: false, errorMessags: "$e");
    }
  }
}
