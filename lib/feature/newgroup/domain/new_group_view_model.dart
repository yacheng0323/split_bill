import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:split_bill/core/repositories/database_service.dart';
import 'package:split_bill/entities/group_table_model.dart';
import 'package:split_bill/entities/result/new_group_result.dart';

part 'new_group_view_model.g.dart';

class NewGroupState {
  final List<String>? members;
  final NewGroupResult? result;

  NewGroupState({this.members, this.result});

  NewGroupState copyWith({List<String>? members, NewGroupResult? result}) {
    return NewGroupState(
      members: members ?? this.members,
      result: result ?? this.result,
    );
  }
}

@Riverpod(keepAlive: true)
class NewGroupViewModel extends _$NewGroupViewModel {
  DatabaseService get _dbService => ref.read(databaseServiceProvider.notifier);

  @override
  NewGroupState build() {
    return NewGroupState();
  }

  void addMember(String name) {
    if (name.trim().isEmpty) return;
    if (state.members?.contains(name) ?? false) return;

    state = state.copyWith(
      members: [...state.members ?? [], name],
    );
  }

  void removeMember(String name) {
    state = state.copyWith(
        members: state.members?.where((test) => test != name).toList());
  }

  Future<void> submit(String title) async {
    try {
      final tableId =
          await _dbService.createTableAndReturnId(GroupTableModel(name: title));
      await _dbService.insertTableMembers(tableId, state.members ?? []);
      state = state.copyWith(result: NewGroupResult(isSuccess: true));
    } catch (e) {
      state = state.copyWith(
          result: NewGroupResult(isSuccess: false, errorMessage: e.toString()));
    }
  }
}
