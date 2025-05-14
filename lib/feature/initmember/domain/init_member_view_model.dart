import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/subjects.dart';
import 'package:split_bill/core/repositories/database_service.dart';
import 'package:split_bill/entities/group_table_model.dart';

part 'init_member_view_model.g.dart';

class InitMemberState {
  final List<String>? members;
  final String? billTitle;

  InitMemberState({this.members, this.billTitle});

  InitMemberState copyWith({List<String>? members, String? billTitle}) {
    return InitMemberState(
        members: members ?? this.members,
        billTitle: billTitle ?? this.billTitle);
  }
}

@riverpod
class InitMemberViewModel extends _$InitMemberViewModel {
  DatabaseService get _dbService => ref.read(databaseServiceProvider.notifier);

  @override
  InitMemberState build() {
    return InitMemberState();
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
        members: state.members?.where((e) => e != name).toList());
  }

  Future<void> submit(String billTitle) async {
    final tableId = await _dbService
        .createTableAndReturnId(GroupTableModel(name: billTitle));
    await _dbService.insertTableMembers(tableId, state.members ?? []);
  }
}
