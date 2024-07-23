import 'package:flutter/material.dart';
import 'package:split_bill/config/injections.dart';
import 'config/router.dart' as router;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjections();
  runApp(const SplitBillApp());
}

class SplitBillApp extends StatefulWidget {
  const SplitBillApp({super.key});

  @override
  State<SplitBillApp> createState() => _SplitBillAppState();
}

class _SplitBillAppState extends State<SplitBillApp> {
  router.Router appRouter = router.Router();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      title: "Split Bill",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
