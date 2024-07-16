// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:split_bill/feature/billhome/ui/bill_home_page.dart' as _i1;
import 'package:split_bill/feature/initgroup/ui/init_group_page.dart' as _i2;
import 'package:split_bill/feature/initmember/ui/init_member_page.dart' as _i3;
import 'package:split_bill/feature/newgroup/ui/new_group_page.dart' as _i4;

abstract class $Router extends _i5.RootStackRouter {
  $Router({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    BillHomeRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.BillHomePage(),
      );
    },
    InitGroupRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.InitGroupPage(),
      );
    },
    InitMemberRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.InitMemberPage(),
      );
    },
    NewGroupRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.NewGroupPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.BillHomePage]
class BillHomeRoute extends _i5.PageRouteInfo<void> {
  const BillHomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          BillHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'BillHomeRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i2.InitGroupPage]
class InitGroupRoute extends _i5.PageRouteInfo<void> {
  const InitGroupRoute({List<_i5.PageRouteInfo>? children})
      : super(
          InitGroupRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitGroupRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i3.InitMemberPage]
class InitMemberRoute extends _i5.PageRouteInfo<void> {
  const InitMemberRoute({List<_i5.PageRouteInfo>? children})
      : super(
          InitMemberRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitMemberRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i4.NewGroupPage]
class NewGroupRoute extends _i5.PageRouteInfo<void> {
  const NewGroupRoute({List<_i5.PageRouteInfo>? children})
      : super(
          NewGroupRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewGroupRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}
