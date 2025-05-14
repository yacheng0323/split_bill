import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/feature/billhome/ui/bill_home_page.dart';
import 'package:split_bill/feature/editbill/ui/edit_bill_page.dart';
import 'package:split_bill/feature/initgroup/ui/init_group_page.dart';
import 'package:split_bill/feature/initmember/ui/init_member_page.dart';
import 'package:split_bill/feature/newbill/ui/new_bill_page.dart';
import 'package:split_bill/feature/newgroup/ui/new_group_page.dart';
import 'package:split_bill/feature/newmember/ui/new_member_page.dart';

class AppRoutes {
  static const String Init_Group = "/initGroupPage";
  static const String Init_Member = "/initMemberPage";
  static const String New_Group = "/NewGroupPage";
  static const String New_Member = "/NewMemberPage";
  static const String New_Bill = "/NewBillPage";
  static const String Edit_Bill = "/EditBillPage";
  static const String Home = "/";
}

// import 'router.gr.dart';

// @AutoRouterConfig()
// class Router extends $Router {
//   @override
//   List<AutoRoute> get routes => [
//         AutoRoute(page: BillHomeRoute.page, initial: true),
//         AutoRoute(page: InitGroupRoute.page),
//         AutoRoute(page: InitMemberRoute.page),
//         AutoRoute(page: NewGroupRoute.page),
//         AutoRoute(page: NewMemberRoute.page),
//         AutoRoute(page: NewBillRoute.page),
//         AutoRoute(page: EditBillRoute.page),
//       ];
// }

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/",
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: "/",
        name: "home",
        builder: (context, state) => const BillHomePage(),
      ),
      GoRoute(
        path: AppRoutes.Init_Group,
        name: AppRoutes.Init_Group,
        builder: (context, state) => const InitGroupPage(),
      ),
      GoRoute(
        path: AppRoutes.Init_Member,
        name: AppRoutes.Init_Member,
        builder: (context, state) => InitMemberPage(
          billTitle: state.uri.queryParameters["title"] ?? "",
        ),
      ),
      GoRoute(
        path: AppRoutes.New_Group,
        name: AppRoutes.New_Group,
        builder: (context, state) => const NewGroupPage(),
      ),
      GoRoute(
        path: AppRoutes.New_Member,
        name: AppRoutes.New_Member,
        builder: (context, state) => NewMemberPage(
          tableId:
              int.tryParse(state.uri.queryParameters["tableId"] ?? "") ?? 0,
        ),
      ),
      GoRoute(
        path: AppRoutes.New_Bill,
        name: AppRoutes.New_Bill,
        builder: (context, state) => NewBillPage(
          tableId:
              int.tryParse(state.uri.queryParameters["tableId"] ?? "") ?? 0,
        ),
      ),
      GoRoute(
        path: AppRoutes.Edit_Bill,
        name: AppRoutes.Edit_Bill,
        builder: (context, state) {
          final billModel = state.extra as BillModel;
          return EditBillPage(
            billModel: billModel,
            tableId: int.parse(state.uri.queryParameters["tableId"] ?? ""),
          );
        },
      ),
    ],
  );
});
