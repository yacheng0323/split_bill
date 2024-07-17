import 'package:get_it/get_it.dart';
import 'package:split_bill/core/database/database_service.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  sl.registerSingleton<DatabaseService>(DatabaseService());
}
