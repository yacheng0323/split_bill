import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:split_bill/config/router.gr.dart';
import 'package:split_bill/core/ui/color.dart';
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

class _BillHomePageState extends State<BillHomePage>
    with SingleTickerProviderStateMixin {
  late BillHomeViewModel billHomeViewModel;
  late TabController tabController;
  late TextEditingController titleController;

  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);

 

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
                  final List<Widget> tablesNames = [
                    for (var item in tables)
                      GestureDetector(
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
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(Icons.clear),
                                        ),
                                      ),
                                      Text(
                                        "Edit Group",
                                        style: TextGetter.headline6?.copyWith(
                                            color: BillColors.contentTextColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 16),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
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
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  30)
                                            ],
                                            decoration: InputDecoration(
                                                hintText: "Enter A Group Name",
                                                hintStyle: TextGetter.bodyText1
                                                    ?.copyWith(
                                                        color: const Color(
                                                            0xffAAAAAA)),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 7.5),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              BillColors
                                                                  .lightYellow,
                                                          elevation: 2),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: SizedBox(
                                                              height: 220,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: Column(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: IconButton(
                                                                        padding: EdgeInsets.zero,
                                                                        constraints: const BoxConstraints(),
                                                                        onPressed: () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        icon: const Icon(Icons.clear)),
                                                                  ),
                                                                  Text(
                                                                    "Delete Group",
                                                                    style: TextGetter
                                                                        .headline6
                                                                        ?.copyWith(
                                                                            color:
                                                                                BillColors.contentTextColor,
                                                                            fontWeight: FontWeight.w700),
                                                                  ),
                                                                  const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              2)),
                                                                  Text(
                                                                    "All the data will be cleared.\n Are you sure to delete it?",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextGetter
                                                                        .bodyText1
                                                                        ?.copyWith(
                                                                      color: const Color(
                                                                          0xffAAAAAA),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            16,
                                                                        vertical:
                                                                            16),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              backgroundColor: BillColors.lightYellow,
                                                                              elevation: 2),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "No",
                                                                            style:
                                                                                TextGetter.bodyText1?.copyWith(color: BillColors.contentTextColor),
                                                                          ),
                                                                        )),
                                                                        const SizedBox(
                                                                            width:
                                                                                8),
                                                                        Expanded(
                                                                            child:
                                                                                ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              backgroundColor: BillColors.deepYellow,
                                                                              elevation: 2),
                                                                          onPressed:
                                                                              () async {
                                                                            await vm.deleteGroup(item.id ??
                                                                                0);
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Yes",
                                                                            style:
                                                                                TextGetter.bodyText1?.copyWith(color: Colors.white),
                                                                          ),
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Text(
                                                    "Delete",
                                                    style: TextGetter.bodyText1
                                                        ?.copyWith(
                                                            color: BillColors
                                                                .contentTextColor),
                                                  )),
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.all(4)),
                                            Expanded(
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              BillColors
                                                                  .deepYellow,
                                                          elevation: 2),
                                                  onPressed: () async {
                                                    await vm.updateTableName(
                                                        titleController.text,
                                                        item.id ?? 0);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Update",
                                                    style: TextGetter.bodyText1
                                                        ?.copyWith(
                                                            color:
                                                                Colors.white),
                                                  )),
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
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, -4),
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 15,
                                  spreadRadius: -2,
                                )
                              ],
                              color: item.id == vm.tableId
                                  ? BillColors.deepYellow
                                  : BillColors.lightYellow,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8))),
                          child: Text(
                            item.name,
                            style: TextGetter.botton?.copyWith(
                                color: item.id == vm.tableId
                                    ? Colors.white
                                    : BillColors.contentTextColor),
                          ),
                        ),
                      ),
                    const Padding(padding: EdgeInsets.all(4)), 
                  ];
                  return Scaffold(
                    backgroundColor: BillColors.backgroundColor,
                    appBar: AppBar(
                      backgroundColor: BillColors.backgroundColor,
                      title: Text(
                        "Split Bill",
                        style: TextGetter.headline6
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    body: tables.isNotEmpty
                        ? SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ...tablesNames,
                                      SizedBox(
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
                                            AutoRouter.of(context)
                                                .push(const NewGroupRoute())
                                                .then((value) async {
                                              if (value == true) {
                                                await vm.initData();
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 32, 12, 32),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            spreadRadius: 1,
                                            blurRadius: 12,
                                            offset: const Offset(0, 4))
                                      ],
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              color:
                                                  BillColors.sectionTitleColor),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          child: Text(
                                            "Overview",
                                            style: TextGetter.botton?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        StreamBuilder<List<DebtModel>?>(
                                            stream: vm.debtList,
                                            builder: (context, snapshot) {
                                              final debtList =
                                                  snapshot.data ?? [];
                                              return debtList.isEmpty
                                                  ? Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(
                                                          0, 8, 0, 24),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color: BillColors
                                                              .lightYellow,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                    )
                                                  : Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(
                                                          0, 8, 0, 24),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              debtList[index];
                                                          Color textColor = index %
                                                                      2 ==
                                                                  0
                                                              ? BillColors
                                                                  .contentTextColor
                                                              : Colors.white;
                                                          TextStyle? textstyle =
                                                              TextGetter
                                                                  .bodyText1
                                                                  ?.copyWith(
                                                                      color:
                                                                          textColor);
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 8),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? BillColors
                                                                        .lightYellow
                                                                    : BillColors
                                                                        .deepYellow),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    item.debtor,
                                                                    style:
                                                                        textstyle,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    "owes",
                                                                    style:
                                                                        textstyle,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    item.creditor,
                                                                    style:
                                                                        textstyle,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    "\$${item.amount}",
                                                                    style:
                                                                        textstyle,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        itemCount:
                                                            debtList.length,
                                                      ),
                                                    );
                                            }),
                                        Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              color:
                                                  BillColors.sectionTitleColor),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          child: Text(
                                            "Bills Detail",
                                            style: TextGetter.botton?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        StreamBuilder<List<BillModel>?>(
                                            stream: vm.billList,
                                            builder: (context, snapshot) {
                                              final billList =
                                                  snapshot.data ?? [];
                                              return billList.isEmpty
                                                  ? Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(0, 8, 0, 0),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color: BillColors
                                                              .lightYellow,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                    )
                                                  : ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final item =
                                                            billList[index];
                                                        TextStyle? textStyle =
                                                            TextGetter
                                                                .bodyText1;
                                                        return GestureDetector(
                                                          onTap: () {
                                                            AutoRouter.of(
                                                                    context)
                                                                .push(EditBillRoute(
                                                                    billModel:
                                                                        item,
                                                                    tableId:
                                                                        item.id ??
                                                                            0))
                                                                .then(
                                                                    (value) async {
                                                              if (value ==
                                                                  true) {
                                                                await vm
                                                                    .initData();
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 8, 0, 0),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        10),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration: BoxDecoration(
                                                                color: BillColors
                                                                    .lightYellow,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        DateFormat("dd MMM")
                                                                            .format(
                                                                          DateTime.fromMillisecondsSinceEpoch(item.dateTime *
                                                                              1000),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        item.title,
                                                                        style:
                                                                            textStyle,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            20),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        item.paidBy,
                                                                        style:
                                                                            textStyle,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "\$${item.money}",
                                                                        style:
                                                                            textStyle,
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 16),
                                                                Row(
                                                                  children: [
                                                                    const Spacer(),
                                                                    const Text(
                                                                        "Settled By "),
                                                                    Row(
                                                                      children: item
                                                                          .settledBy
                                                                          .map(
                                                                              (settle) {
                                                                        return Container(
                                                                          margin: const EdgeInsets
                                                                              .all(
                                                                              2),
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 3,
                                                                              vertical: 0.5),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(3),
                                                                              color: Colors.white),
                                                                          child: Text(settle.substring(
                                                                              0,
                                                                              2)),
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
                                                      itemCount:
                                                          billList.length,
                                                    );
                                            }),
                          
                                       
                                      ],
                                    ),
                                  ),
                                ],
                                          
                              ),
                            ),
                          )
                        : Center(
                            child: Image.asset(
                              width: 302,
                              height: 302,
                              "image/ellipse.png",
                            ),
                          ),
                    bottomNavigationBar: tables.isNotEmpty
                        ? const SizedBox.shrink()
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 88),
                            child: SafeArea(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 29),
                                    backgroundColor: BillColors.deepYellow),
                                onPressed: () {
                                  AutoRouter.of(context)
                                      .replace(const InitGroupRoute());
                                },
                                child: Text(
                                  "Create A New Group",
                                  style: TextGetter.headline6
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                    floatingActionButton: tables.isNotEmpty
                        ? SpeedDial(
                            backgroundColor: BillColors.deepYellow,
                            foregroundColor: Colors.white,
                            icon: Icons.add,
                            activeIcon: Icons.close,
                            spacing: 12,
                            mini: mini,
                            openCloseDial: isDialOpen,
                            childPadding: const EdgeInsets.all(5),
                            spaceBetweenChildren: 4,
                            dialRoot: customDialRoot
                                ? (ctx, open, toggleChildren) {
                                    return ElevatedButton(
                                      onPressed: toggleChildren,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue[900],
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 22, vertical: 18),
                                      ),
                                      child: const Text(
                                        "Custom Dial Root",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    );
                                  }
                                : null,
                            buttonSize: Size(64.0, 64.0),
                            childrenButtonSize: Size(60.0, 60.0),
                            visible: visible,
                            direction: SpeedDialDirection.up,
                            switchLabelPosition: switchLabelPosition,
                            closeManually: closeManually,
                            renderOverlay: renderOverlay,
                            onOpen: () => debugPrint('OPENING DIAL'),
                            onClose: () => debugPrint('DIAL CLOSED'),
                            useRotationAnimation: true,
                            tooltip: 'Open Speed Dial',
                            heroTag: 'speed-dial-hero-tag',
                            elevation: 8.0,
                            animationCurve: Curves.elasticInOut,
                            isOpenOnStart: false,
                            shape: const StadiumBorder(),
                            children: [
                              SpeedDialChild(
                                child: const Icon(Icons.assignment),
                                backgroundColor: BillColors.lightYellow,
                                foregroundColor: BillColors.contentTextColor,
                                label: "New Bill",
                                onTap: () {
                                  AutoRouter.of(context).push(
                                      NewBillRoute(
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
                                child: const Icon(
                                    Icons.sentiment_satisfied_alt_rounded),
                                backgroundColor: BillColors.lightYellow,
                                foregroundColor: BillColors.contentTextColor,
                                label: "New Member",
                                onTap: () {
                                  AutoRouter.of(context).push(
                                      NewMemberRoute(tableId: vm.tableId ?? 0));
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  );
                });
          },
        );
      },
    );
  }
}
