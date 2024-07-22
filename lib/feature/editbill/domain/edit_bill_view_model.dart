import 'package:get_it/get_it.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:split_bill/core/database/database_service.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/result/edit_bill_result.dart';

class EditBillViewModel {
  final _members = BehaviorSubject<List<String>?>.seeded(null);

  ValueStream<List<String>?> get members => _members;

  final _settledMembers = BehaviorSubject<List<String>>.seeded([]);

  ValueStream<List<String>> get settledMembers => _settledMembers;

  final _dateTime = BehaviorSubject<DateTime>.seeded(DateTime.now());

  DateTime get dateTime => _dateTime.value;

  Future<void> init(int tableId, List<String> settledMembers) async {
    final dbService = GetIt.I.get<DatabaseService>();

    List<String> memberList = await dbService.getTableMembers(tableId);
    _settledMembers.add(settledMembers);
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

  Future<EditBillResult> updateBill(
    int billid,
    int tableId,
    String title,
    double money,
    String paidBy,
  ) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      BillModel bill = BillModel(
        id: billid,
        tableId: tableId,
        title: title,
        dateTime: _dateTime.value.millisecondsSinceEpoch ~/ 1000,
        money: money,
        paidBy: paidBy,
        settledBy: _settledMembers.value,
      );
      await dbService.updateBill(bill);
      return EditBillResult(
        isSuccess: true,
      );
    } catch (e) {
      return EditBillResult(isSuccess: false, errorMessags: "$e");
    }
  }
}
