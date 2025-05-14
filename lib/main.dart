import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:split_bill/config/injections.dart';
import 'package:split_bill/config/router.dart';
import 'config/router.dart' as router;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjections();
  runApp(const SplitBillApp());
}

class SplitBillApp extends ConsumerStatefulWidget {
  const SplitBillApp({super.key});

  @override
  ConsumerState<SplitBillApp> createState() => _SplitBillAppState();
}

class _SplitBillAppState extends ConsumerState<SplitBillApp> {
  // router.Router appRouter = router.Router();

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      // routerConfig: appRouter.config,
      routerConfig: router,
      title: "Split Bill",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
