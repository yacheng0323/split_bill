import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';
import 'package:split_bill/core/database/database_service.dart';
import 'package:split_bill/entities/group_table_model.dart';
import 'package:split_bill/entities/result/new_group_result.dart';

class NewGroupViewModel {
  final _members = BehaviorSubject<List<String>>.seeded([]);

  Stream<List<String>> get members => _members;

  void addMember(String name) {
    final list = _members.value;
    list.add(name);
    _members.add(List.from(list));
  }

  void removeMember(String name) {
    final list = _members.value;
    list.remove(name);
    _members.add(List.from(list));
  }

  Future<NewGroupResult> submit(String title) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      final tableId = await dbService.createTableAndReturnId(GroupTableModel(name: title));
      await dbService.insertTableMembers(tableId, _members.value);
      return NewGroupResult(isSuccess: true);
    } catch (e) {
      return NewGroupResult(isSuccess: false, errorMessage: "$e");
    }
  }
}
