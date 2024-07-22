import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';
import 'package:split_bill/core/database/database_service.dart';
import 'package:split_bill/entities/result/insert_member_result.dart';

class NewMemberViewModel {
  final _result = BehaviorSubject<InsertMemberResult?>.seeded(null);

  InsertMemberResult? get result => _result.value;

  final _members = BehaviorSubject<List<String>?>.seeded(null);

  List<String>? get members => _members.value;

  Future<void> getMembers(int tableId) async {
    final dbService = GetIt.I.get<DatabaseService>();
    _members.add(await dbService.getTableMembers(tableId));
  }

  Future<void> addMember(int tableId, String member) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      await dbService.insertTableMembers(tableId, [member]);
      _result.add(InsertMemberResult(isSuccess: true));
    } catch (e) {
      _result.add(
        InsertMemberResult(isSuccess: false, errorMessags: "Failed to add member. Please try again later."),
      );
    }
  }
}
