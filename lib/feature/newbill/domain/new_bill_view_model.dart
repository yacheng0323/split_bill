import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:split_bill/core/repositories/database_service.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/result/new_bill_result.dart';

part 'new_bill_view_model.g.dart';

class NewBillState {
  final List<String>? members;
  final List<String>? settledMembers;
  final DateTime? dateTime;
  final NewBillResult? result;

  NewBillState({this.members, this.settledMembers, this.dateTime, this.result});

  NewBillState copyWith(
      {List<String>? members,
      List<String>? settledMembers,
      DateTime? dateTime,
      NewBillResult? result}) {
    return NewBillState(
        members: members ?? this.members,
        settledMembers: settledMembers ?? this.settledMembers,
        dateTime: dateTime ?? this.dateTime,
        result: result ?? this.result);
  }
}

@riverpod
class NewBillViewModel extends _$NewBillViewModel {
  @override
  Future<NewBillState> build() async {
    return NewBillState();
  }

  Future<void> init(int tableId) async {
    final dbService = ref.watch(databaseServiceProvider.notifier);

    List<String> memberList = await dbService.getTableMembers(tableId);
    state = AsyncValue.data(state.value!.copyWith(members: memberList));
  }

  void toggleSettledMember(String name) async {
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

  Future<void> addBill({
    required int tableId,
    required String title,
    required double money,
    required String paidBy,
  }) async {
    try {
      final dbService = ref.read(databaseServiceProvider.notifier);
      await dbService.insertBill(
        BillModel(
          title: title,
          dateTime: (state.value!.dateTime!.millisecondsSinceEpoch ~/ 1000),
          tableId: tableId,
          money: money,
          paidBy: paidBy,
          settledBy: state.value!.settledMembers ?? [],
        ),
      );
      state = AsyncValue.data(
          state.value!.copyWith(result: NewBillResult(isSuccess: true)));
      return;
    } catch (e) {
      state = AsyncValue.data(state.value!.copyWith(
          result: NewBillResult(isSuccess: false, errorMessage: "$e")));
      return;
    }
  }
}
