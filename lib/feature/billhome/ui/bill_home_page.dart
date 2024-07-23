import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:split_bill/config/router.gr.dart';
import 'package:split_bill/core/ui/color.dart';
import 'package:split_bill/core/ui/show_snack_bar.dart';
import 'package:split_bill/core/ui/textstyle.dart';
import 'package:split_bill/entities/bill_model.dart';
import 'package:split_bill/entities/debt_model.dart';
import 'package:split_bill/entities/group_table_model.dart';
import 'package:split_bill/feature/billhome/domain/bill_home_view_model.dart';

@RoutePage()
class BillHomePage extends StatefulWidget {
  const BillHomePage({super.key});

  @override
  State<BillHomePage> createState() => _BillHomePageState();
}

class _BillHomePageState extends State<BillHomePage> with SingleTickerProviderStateMixin {
  late BillHomeViewModel billHomeViewModel;
  late TabController tabController;
  late TextEditingController titleController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    billHomeViewModel = BillHomeViewModel();
    titleController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<BillHomeViewModel>(
      create: (context) {
        billHomeViewModel.initData();
        return billHomeViewModel;
      },
      builder: (context, child) {
        return Consumer<BillHomeViewModel>(
          builder: (context, vm, child) {
            return StreamBuilder<List<GroupTableModel>?>(
                stream: vm.groupTables,
                builder: (context, snapshot) {
                  final tables = snapshot.data ?? [];
                  return Scaffold(
                    backgroundColor: BillColors.backgroundColor,
                    appBar: AppBar(
                      backgroundColor: BillColors.backgroundColor,
                      title: Text(
                        "Split Bill",
                        style: TextGetter.headline6?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    body: tables.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await vm.initData();
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: 40,
                                        child: ListView.builder(
                                          padding: const EdgeInsets.only(top: 8),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: tables.length + 1,
                                          itemBuilder: (context, index) {
                                            if (index == tables.length) {
                                              return SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Color(0xffAAAAAA),
                                                  ),
                                                  onPressed: () {
                                                    AutoRouter.of(context).push(const NewGroupRoute()).then((value) async {
                                                      if (value == true) {
                                                        await vm.initData();
                                                      }
                                                    });
                                                  },
                                                ),
                                              );
                                            } else {
                                              final item = tables[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  vm.changeGroup(item.id ?? 0);
                                                },
                                                onLongPress: () {
                                                  titleController.text = item.name;
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor: Colors.white,
                                                        child: SizedBox(
                                                          height: 220,
                                                          width: MediaQuery.of(context).size.width,
                                                          child: Column(
                                                            children: [
                                                              _buildCloseButton(),
                                                              _buildDialogTitle(),
                                                              _buildGroupNameField(
                                                                titleController: titleController,
                                                              ),
                                                              _buildDialogButtons(vm: vm, titleController: titleController, item: item),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: _buildGroupItem(item: item, vm: vm),
                                              );
                                            }
                                          },
                                        )),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(12, 32, 12, 32),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.25),
                                            spreadRadius: 1,
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                color: BillColors.sectionTitleColor),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            child: Text(
                                              "Overview",
                                              style: TextGetter.botton?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          StreamBuilder<List<DebtModel>?>(
                                              stream: vm.debtList,
                                              builder: (context, snapshot) {
                                                final debtList = snapshot.data ?? [];
                                                return debtList.isEmpty
                                                    ? Container(
                                                        margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: BillColors.lightYellow,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      )
                                                    : Container(
                                                        margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                                                        width: MediaQuery.of(context).size.width,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: ListView.builder(
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemBuilder: (context, index) {
                                                            final item = debtList[index];
                                                            Color textColor = index % 2 == 0 ? BillColors.contentTextColor : Colors.white;
                                                            TextStyle? textstyle = TextGetter.bodyText1?.copyWith(color: textColor);
                                                            return Container(
                                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                color: index % 2 == 0 ? BillColors.lightYellow : BillColors.deepYellow,
                                                              ),
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                                vertical: 10,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(item.debtor, style: textstyle, textAlign: TextAlign.left),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text("owes", style: textstyle, textAlign: TextAlign.center),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(item.creditor, style: textstyle, textAlign: TextAlign.center),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text("\$${item.amount.toStringAsFixed(0)}", style: textstyle, textAlign: TextAlign.end),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          itemCount: debtList.length,
                                                        ),
                                                      );
                                              }),
                                          Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                color: BillColors.sectionTitleColor),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            child: Text(
                                              "Bills Detail",
                                              style: TextGetter.botton?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<List<BillModel>?>(
                                              stream: vm.billList,
                                              builder: (context, snapshot) {
                                                final billList = snapshot.data ?? [];
                                                return billList.isEmpty
                                                    ? Container(
                                                        margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: BillColors.lightYellow,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      )
                                                    : ListView.builder(
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemBuilder: (context, index) {
                                                          final item = billList[index];
                                                          TextStyle? textStyle = TextGetter.bodyText1;
                                                          return GestureDetector(
                                                            onTap: () {
                                                              AutoRouter.of(context).push(EditBillRoute(billModel: item, tableId: item.tableId ?? 0)).then((value) async {
                                                                if (value == true) {
                                                                  await vm.initData();
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                              width: MediaQuery.of(context).size.width,
                                                              decoration: BoxDecoration(
                                                                color: BillColors.lightYellow,
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          DateFormat("dd MMM").format(DateTime.fromMillisecondsSinceEpoch(item.dateTime * 1000)),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(item.title, style: textStyle, textAlign: TextAlign.start),
                                                                      ),
                                                                      const SizedBox(width: 20),
                                                                      Expanded(
                                                                        child: Text(item.paidBy, style: textStyle, textAlign: TextAlign.center),
                                                                      ),
                                                                      Expanded(
                                                                        child: Text("\$${item.money.toStringAsFixed(0)}", style: textStyle, textAlign: TextAlign.end),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 16),
                                                                  Row(
                                                                    children: [
                                                                      const Spacer(),
                                                                      const Text("Settled By "),
                                                                      Row(
                                                                        children: item.settledBy.map((settle) {
                                                                          return Container(
                                                                            margin: const EdgeInsets.all(2),
                                                                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(3),
                                                                              color: Colors.white,
                                                                            ),
                                                                            child: Text(settle.length > 2 ? settle.substring(0, 2) : settle),
                                                                          );
                                                                        }).toList(),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        itemCount: billList.length,
                                                      );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Image.asset(width: 302, height: 302, "image/ellipse.png"),
                          ),
                    bottomNavigationBar: tables.isNotEmpty
                        ? const SizedBox.shrink()
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: SafeArea(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 29),
                                  backgroundColor: BillColors.deepYellow,
                                ),
                                onPressed: () {
                                  AutoRouter.of(context).replace(const InitGroupRoute());
                                },
                                child: Text(
                                  "Create A New Group",
                                  style: TextGetter.headline6?.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                    floatingActionButton: SpeedDialButton(
                      tables: tables,
                      vm: vm,
                    ),
                  );
                });
          },
        );
      },
    );
  }
}

// ignore: camel_case_types
class _buildCloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.clear),
      ),
    );
  }
}

// ignore: camel_case_types
class _buildDialogTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Edit Group",
      style: TextGetter.headline6?.copyWith(
        color: BillColors.contentTextColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ignore: camel_case_types
class _buildGroupNameField extends StatelessWidget {
  final TextEditingController titleController;
  const _buildGroupNameField({
    required this.titleController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          gradient: const LinearGradient(
            stops: [0.0, 0.02, 0.1, 0.2],
            colors: [
              Color(0xffC5C5C5),
              Color(0xffD4D4D4),
              Color(0xffE7E7E7),
              Color(0xffF9F9F9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TextFormField(
          controller: titleController,
          inputFormatters: [LengthLimitingTextInputFormatter(30)],
          decoration: InputDecoration(
            hintText: "Enter A Group Name",
            hintStyle: TextGetter.bodyText1?.copyWith(color: const Color(0xffAAAAAA)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class _buildDialogButtons extends StatelessWidget {
  final BillHomeViewModel vm;
  final TextEditingController titleController;
  final GroupTableModel item;

  const _buildDialogButtons({
    required this.vm,
    required this.titleController,
    required this.item,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BillColors.lightYellow,
                elevation: 2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                DeleteGroupDialog.show(context, item, vm);
                // showDeleteGroupDialog(context, item);
              },
              child: Text(
                "Delete",
                style: TextGetter.bodyText1?.copyWith(color: BillColors.contentTextColor),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(4)),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BillColors.deepYellow,
                elevation: 2,
              ),
              onPressed: () async {
                final result = await vm.updateGroupName(titleController.text, item.id ?? 0);
                if (result.isSuccess) {
                  // ignore: use_build_context_synchronously
                  ShowSnackBarHelper.successSnackBar(context: context).showSnackbar("Update Successful");
                } else {
                  // ignore: use_build_context_synchronously
                  ShowSnackBarHelper.errorSnackBar(context: context).showSnackbar("Update Failed");
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: Text(
                "Update",
                style: TextGetter.bodyText1?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteGroupDialog {
  static Future<void> show(BuildContext context, GroupTableModel item, BillHomeViewModel vm) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
            height: 220,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                _buildCloseButton(),
                const Text(
                  "Delete Group",
                  style: TextStyle(
                    fontSize: 20, // Replace with TextGetter.headline6
                    color: Colors.black, // Replace with BillColors.contentTextColor
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(2)),
                const Text(
                  "All the data will be cleared.\n Are you sure to delete it?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16, // Replace with TextGetter.bodyText1
                    color: Color(0xffAAAAAA),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[100], // Replace with BillColors.lightYellow
                            elevation: 2,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(
                              fontSize: 16, // Replace with TextGetter.bodyText1
                              color: Colors.black, // Replace with BillColors.contentTextColor
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[800], // Replace with BillColors.deepYellow
                            elevation: 2,
                          ),
                          onPressed: () async {
                            final result = await vm.deleteGroup(item.id ?? 0);
                            if (result.isSuccess) {
                              // ignore: use_build_context_synchronously
                              ShowSnackBarHelper.successSnackBar(context: context).showSnackbar("Deletion Successful");
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            } else {
                              // ignore: use_build_context_synchronously
                              ShowSnackBarHelper.errorSnackBar(context: context).showSnackbar("Deletion Failed");
                            }
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              fontSize: 16, // Replace with TextGetter.bodyText1
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ignore: camel_case_types
class _buildGroupItem extends StatelessWidget {
  final GroupTableModel item;
  final BillHomeViewModel vm;

  const _buildGroupItem({
    required this.item,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            color: Colors.black.withOpacity(0.25),
            blurRadius: 15,
            spreadRadius: -2,
          ),
        ],
        color: item.id == vm.tableId ? BillColors.deepYellow : BillColors.lightYellow,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Text(
        item.name,
        style: TextGetter.botton?.copyWith(
          color: item.id == vm.tableId ? Colors.white : BillColors.contentTextColor,
        ),
      ),
    );
  }
}

class SpeedDialButton extends StatelessWidget {
  final List<GroupTableModel> tables;
  final BillHomeViewModel vm;

  const SpeedDialButton({
    super.key,
    required this.tables,
    required this.vm,
  });
  @override
  Widget build(BuildContext context) {
    return tables.isNotEmpty
        ? SpeedDial(
            backgroundColor: BillColors.deepYellow,
            foregroundColor: Colors.white,
            icon: Icons.add,
            activeIcon: Icons.close,
            spacing: 12,
            spaceBetweenChildren: 4,
            buttonSize: const Size(64.0, 64.0),
            childrenButtonSize: const Size(64.0, 64.0),
            direction: SpeedDialDirection.up,
            switchLabelPosition: false,
            renderOverlay: true,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => debugPrint('OPENING DIAL'),
            onClose: () => debugPrint('DIAL CLOSED'),
            useRotationAnimation: true,
            tooltip: 'Open Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            elevation: 8.0,
            animationCurve: Curves.elasticInOut,
            isOpenOnStart: false,
            children: [
              SpeedDialChild(
                shape: const CircleBorder(),
                child: const Icon(Icons.assignment, size: 32),
                backgroundColor: BillColors.lightYellow,
                foregroundColor: BillColors.contentTextColor,
                label: "New Bill",
                labelBackgroundColor: Colors.transparent,
                labelShadow: [],
                labelStyle: TextGetter.bodyText1?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                onTap: () {
                  AutoRouter.of(context)
                      .push(NewBillRoute(
                    tableId: vm.tableId ?? 0,
                  ))
                      .then((value) async {
                    if (value == true) {
                      await vm.initData();
                    }
                  });
                },
              ),
              SpeedDialChild(
                shape: const CircleBorder(),
                child: const Icon(Icons.sentiment_satisfied_alt_rounded, size: 32),
                backgroundColor: BillColors.lightYellow,
                foregroundColor: BillColors.contentTextColor,
                label: "New Member",
                labelBackgroundColor: Colors.transparent,
                labelShadow: [],
                labelStyle: TextGetter.bodyText1?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                onTap: () {
                  AutoRouter.of(context).push(NewMemberRoute(tableId: vm.tableId ?? 0));
                },
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
