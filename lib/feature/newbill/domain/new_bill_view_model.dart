import 'package:get_it/get_it.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:split_bill/core/database/database_service.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/result/new_bill_result.dart';

class NewBillViewModel {
  final _members = BehaviorSubject<List<String>?>.seeded(null);

  ValueStream<List<String>?> get members => _members;

  final _settledMembers = BehaviorSubject<List<String>>.seeded([]);

  ValueStream<List<String>> get settledMembers => _settledMembers;

  final _dateTime = BehaviorSubject<DateTime>.seeded(DateTime.now());

  DateTime get dateTime => _dateTime.value;

  Future<void> init(int tableId) async {
    final dbService = GetIt.I.get<DatabaseService>();

    List<String> memberList = await dbService.getTableMembers(tableId);
    _members.add(memberList);
  }

  void toggleSettledMember(String name) async {
    final list = _settledMembers.value;
    if (list.contains(name)) {
      list.remove(name);
    } else {
      list.add(name);
    }
    _settledMembers.add(List.from(list));
  }

  void setDateTime(DateTime date) {
    _dateTime.add(date);
  }

  Future<NewBillResult> addBill({
    required int tableId,
    required String title,
    required double money,
    required String paidBy,
  }) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      await dbService.insertBill(
        BillModel(
          title: title,
          dateTime: (_dateTime.value.millisecondsSinceEpoch ~/ 1000),
          tableId: tableId,
          money: money,
          paidBy: paidBy,
          settledBy: _settledMembers.value,
        ),
      );
      return NewBillResult(isSuccess: true);
    } catch (e) {
      return NewBillResult(isSuccess: false, errorMessage: "$e");
    }
  }
}
