import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/subjects.dart';
import 'package:split_bill/core/repositories/database_service.dart';
import 'package:split_bill/entities/result/insert_member_result.dart';

part 'new_member_view_model.g.dart';

class NewMemberState {
  final List<String>? members;
  final InsertMemberResult? result;

  NewMemberState({this.members, this.result});

  NewMemberState copyWith({List<String>? members, InsertMemberResult? result}) {
    return NewMemberState(
      members: members ?? this.members,
      result: result ?? this.result,
    );
  }
}

@riverpod
class NewMemberViewModel extends _$NewMemberViewModel {
  @override
  Future<NewMemberState> build() async {
    return NewMemberState();
  }

  Future<void> getMembers(int tableId) async {
    final dbService = ref.read(databaseServiceProvider.notifier);
    final members = await dbService.getTableMembers(tableId);
    state = AsyncValue.data(state.value!.copyWith(members: members));
  }

  Future<void> addMember(int tableId, String member) async {
    try {
      final dbService = ref.read(databaseServiceProvider.notifier);
      await dbService.insertTableMembers(tableId, [member]);
      state = AsyncValue.data(
          state.value!.copyWith(result: InsertMemberResult(isSuccess: true)));
    } catch (e) {
      state = AsyncValue.data(state.value!.copyWith(
          result: InsertMemberResult(
              isSuccess: false,
              errorMessags: "Failed to add member. Please try again later.")));
    }
  }
}
