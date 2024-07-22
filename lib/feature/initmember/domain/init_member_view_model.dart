import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';
import 'package:split_bill/core/database/database_service.dart';
import 'package:split_bill/entities/group_table_model.dart';

class InitMemberViewModel {
  final _members = BehaviorSubject<List<String>>.seeded([]);

  Stream<List<String>> get members => _members.stream;

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

  Future<void> submit(String billTitle) async {
    final dbService = GetIt.I.get<DatabaseService>();
    final tableId = await dbService.createTableAndReturnId(GroupTableModel(name: billTitle));
    await dbService.insertTableMembers(tableId, _members.value);
  }
}
