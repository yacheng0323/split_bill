import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

@AutoRouterConfig()
class Router extends $Router {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: BillHomeRoute.page, initial: true),
        AutoRoute(page: InitGroupRoute.page),
        AutoRoute(page: InitMemberRoute.page),
        AutoRoute(page: NewGroupRoute.page),
      ];
}
