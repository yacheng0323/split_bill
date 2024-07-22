// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:split_bill/entities/bill_model.dart' as _i10;
import 'package:split_bill/feature/billhome/ui/bill_home_page.dart' as _i1;
import 'package:split_bill/feature/editbill/ui/edit_bill_page.dart' as _i2;
import 'package:split_bill/feature/initgroup/ui/init_group_page.dart' as _i3;
import 'package:split_bill/feature/initmember/ui/init_member_page.dart' as _i4;
import 'package:split_bill/feature/newbill/ui/new_bill_page.dart' as _i5;
import 'package:split_bill/feature/newgroup/ui/new_group_page.dart' as _i6;
import 'package:split_bill/feature/newmember/ui/new_member_page.dart' as _i7;

abstract class $Router extends _i8.RootStackRouter {
  $Router({super.navigatorKey});

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    BillHomeRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.BillHomePage(),
      );
    },
    EditBillRoute.name: (routeData) {
      final args = routeData.argsAs<EditBillRouteArgs>();
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.EditBillPage(
          key: args.key,
          billModel: args.billModel,
          tableId: args.tableId,
        ),
      );
    },
    InitGroupRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.InitGroupPage(),
      );
    },
    InitMemberRoute.name: (routeData) {
      final args = routeData.argsAs<InitMemberRouteArgs>();
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.InitMemberPage(
          key: args.key,
          billTitle: args.billTitle,
        ),
      );
    },
    NewBillRoute.name: (routeData) {
      final args = routeData.argsAs<NewBillRouteArgs>();
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.NewBillPage(
          key: args.key,
          tableId: args.tableId,
        ),
      );
    },
    NewGroupRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.NewGroupPage(),
      );
    },
    NewMemberRoute.name: (routeData) {
      final args = routeData.argsAs<NewMemberRouteArgs>();
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.NewMemberPage(
          key: args.key,
          tableId: args.tableId,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.BillHomePage]
class BillHomeRoute extends _i8.PageRouteInfo<void> {
  const BillHomeRoute({List<_i8.PageRouteInfo>? children})
      : super(
          BillHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'BillHomeRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i2.EditBillPage]
class EditBillRoute extends _i8.PageRouteInfo<EditBillRouteArgs> {
  EditBillRoute({
    _i9.Key? key,
    required _i10.BillModel billModel,
    required int tableId,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          EditBillRoute.name,
          args: EditBillRouteArgs(
            key: key,
            billModel: billModel,
            tableId: tableId,
          ),
          initialChildren: children,
        );

  static const String name = 'EditBillRoute';

  static const _i8.PageInfo<EditBillRouteArgs> page =
      _i8.PageInfo<EditBillRouteArgs>(name);
}

class EditBillRouteArgs {
  const EditBillRouteArgs({
    this.key,
    required this.billModel,
    required this.tableId,
  });

  final _i9.Key? key;

  final _i10.BillModel billModel;

  final int tableId;

  @override
  String toString() {
    return 'EditBillRouteArgs{key: $key, billModel: $billModel, tableId: $tableId}';
  }
}

/// generated route for
/// [_i3.InitGroupPage]
class InitGroupRoute extends _i8.PageRouteInfo<void> {
  const InitGroupRoute({List<_i8.PageRouteInfo>? children})
      : super(
          InitGroupRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitGroupRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i4.InitMemberPage]
class InitMemberRoute extends _i8.PageRouteInfo<InitMemberRouteArgs> {
  InitMemberRoute({
    _i9.Key? key,
    required String billTitle,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          InitMemberRoute.name,
          args: InitMemberRouteArgs(
            key: key,
            billTitle: billTitle,
          ),
          initialChildren: children,
        );

  static const String name = 'InitMemberRoute';

  static const _i8.PageInfo<InitMemberRouteArgs> page =
      _i8.PageInfo<InitMemberRouteArgs>(name);
}

class InitMemberRouteArgs {
  const InitMemberRouteArgs({
    this.key,
    required this.billTitle,
  });

  final _i9.Key? key;

  final String billTitle;

  @override
  String toString() {
    return 'InitMemberRouteArgs{key: $key, billTitle: $billTitle}';
  }
}

/// generated route for
/// [_i5.NewBillPage]
class NewBillRoute extends _i8.PageRouteInfo<NewBillRouteArgs> {
  NewBillRoute({
    _i9.Key? key,
    required int tableId,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          NewBillRoute.name,
          args: NewBillRouteArgs(
            key: key,
            tableId: tableId,
          ),
          initialChildren: children,
        );

  static const String name = 'NewBillRoute';

  static const _i8.PageInfo<NewBillRouteArgs> page =
      _i8.PageInfo<NewBillRouteArgs>(name);
}

class NewBillRouteArgs {
  const NewBillRouteArgs({
    this.key,
    required this.tableId,
  });

  final _i9.Key? key;

  final int tableId;

  @override
  String toString() {
    return 'NewBillRouteArgs{key: $key, tableId: $tableId}';
  }
}

/// generated route for
/// [_i6.NewGroupPage]
class NewGroupRoute extends _i8.PageRouteInfo<void> {
  const NewGroupRoute({List<_i8.PageRouteInfo>? children})
      : super(
          NewGroupRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewGroupRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i7.NewMemberPage]
class NewMemberRoute extends _i8.PageRouteInfo<NewMemberRouteArgs> {
  NewMemberRoute({
    _i9.Key? key,
    required int tableId,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          NewMemberRoute.name,
          args: NewMemberRouteArgs(
            key: key,
            tableId: tableId,
          ),
          initialChildren: children,
        );

  static const String name = 'NewMemberRoute';

  static const _i8.PageInfo<NewMemberRouteArgs> page =
      _i8.PageInfo<NewMemberRouteArgs>(name);
}

class NewMemberRouteArgs {
  const NewMemberRouteArgs({
    this.key,
    required this.tableId,
  });

  final _i9.Key? key;

  final int tableId;

  @override
  String toString() {
    return 'NewMemberRouteArgs{key: $key, tableId: $tableId}';
  }
}
