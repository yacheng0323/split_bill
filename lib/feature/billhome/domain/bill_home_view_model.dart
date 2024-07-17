import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';
import 'package:split_bill/core/database/database_service.dart';
import 'package:split_bill/entities/group_table_model.dart';

class BillHomeViewModel {
  final _groupTables = BehaviorSubject<List<GroupTableModel>?>.seeded(null);

  Stream<List<GroupTableModel>?> get groupTables => _groupTables.stream;

  final _tableId = BehaviorSubject<int?>.seeded(null);

  int? get tableId => _tableId.value;

  Future<void> initData() async {
    final dbService = GetIt.I.get<DatabaseService>();
    final list = await dbService.getTables();
    _tableId.add(list[0].id);
    _groupTables.add(list);
    // await dbService.getTableMembers(tableId);
  }
}
