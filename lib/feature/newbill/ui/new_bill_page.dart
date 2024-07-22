import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:split_bill/core/ui/color.dart';
import 'package:split_bill/core/ui/show_snack_bar.dart';
import 'package:split_bill/core/ui/textstyle.dart';
import 'package:split_bill/feature/billhome/domain/bill_home_view_model.dart';
import 'package:split_bill/feature/newbill/domain/new_bill_view_model.dart';

@RoutePage()
class NewBillPage extends StatefulWidget {
  const NewBillPage({super.key, required this.tableId});

  final int tableId;

  @override
  State<NewBillPage> createState() => _NewBillPageState();
}

class _NewBillPageState extends State<NewBillPage> {
  late NewBillViewModel newBillViewModel;
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController paidByController = TextEditingController();
  final TextEditingController settledByController = TextEditingController();

  @override
  void initState() {
    newBillViewModel = NewBillViewModel();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    amountController.dispose();
    paidByController.dispose();
    settledByController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BillColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: BillColors.backgroundColor,
          title: Text(
            "New Bill",
            style: TextGetter.headline6?.copyWith(color: BillColors.contentTextColor, fontWeight: FontWeight.w700),
          ),
        ),
        body: Provider<NewBillViewModel>(create: (context) {
          newBillViewModel.init(widget.tableId);
          return newBillViewModel;
        }, builder: (context, child) {
          return Consumer<NewBillViewModel>(
            builder: (context, vm, child) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              spreadRadius: 1,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 32, 12, 0),
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
                                  onChanged: (value) {},
                                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Title'; // Error message if the field is empty
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Enter A Title",
                                    hintStyle: TextGetter.bodyText1?.copyWith(color: const Color(0xffAAAAAA)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
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
                                  controller: dateController,
                                  onChanged: (value) {},
                                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                                  readOnly: true,
                                  onTap: () {
                                    DatePicker.showDatePicker(
                                      maxTime: DateTime.now(),
                                      context,
                                      onConfirm: (date) {
                                        vm.setDateTime(date);
                                        setState(() {
                                          dateController.text = DateFormat("yyyy/MM/dd").format(date);
                                        });
                                      },
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select Date'; // Error message if the field is empty
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xffAAAAAA),
                                    ),
                                    hintText: "Select date",
                                    hintStyle: TextGetter.bodyText1?.copyWith(color: const Color(0xffAAAAAA)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
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
                                  controller: amountController,
                                  onChanged: (value) {
                                    final text = amountController.text;

                                    if (text.isNotEmpty && !text.startsWith('\$')) {
                                      amountController.value = TextEditingValue(
                                        text: '\$$text',
                                        selection: TextSelection.fromPosition(
                                          TextPosition(offset: text.length + 1),
                                        ),
                                      );
                                    }
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(20),
                                    FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*')),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Amount'; // Error message if the field is empty
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Enter The Amount",
                                    hintStyle: TextGetter.bodyText1?.copyWith(color: const Color(0xffAAAAAA)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            StreamBuilder<List<String>?>(
                                stream: vm.members,
                                builder: (context, snapshot) {
                                  final members = snapshot.data ?? [];
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
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
                                        controller: paidByController,
                                        onChanged: (value) {},
                                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select member'; // Error message if the field is empty
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        onTap: () {
                                          showBarModalBottomSheet(
                                            barrierColor: Colors.black54,
                                            context: context,
                                            expand: false,
                                            builder: (context) {
                                              return SingleChildScrollView(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: ListView.separated(
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: members.length,
                                                    itemBuilder: (context, index) {
                                                      return ListTile(
                                                        title: Center(
                                                          child: Text(members[index]),
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            paidByController.text = members[index];
                                                          });
                                                          Navigator.of(context).pop();
                                                        },
                                                      );
                                                    },
                                                    separatorBuilder: (BuildContext context, int index) {
                                                      return const Divider(
                                                        height: 1,
                                                        color: Color(0xffECECEC),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Color(0xffAAAAAA),
                                          ),
                                          hintText: "Paid By",
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
                                }),
                            StreamBuilder<List<String>?>(
                                stream: vm.members,
                                builder: (context, snapshot) {
                                  final members = snapshot.data ?? [];
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
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
                                        controller: settledByController,
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select member'; // Error message if the field is empty
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          showBarModalBottomSheet(
                                            barrierColor: Colors.black54,
                                            context: context,
                                            expand: false,
                                            builder: (context) {
                                              return StreamBuilder<List<String>>(
                                                  stream: vm.settledMembers,
                                                  builder: (context, snapshot) {
                                                    final selectedList = snapshot.data ?? [];
                                                    return SingleChildScrollView(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        child: ListView.separated(
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount: members.length,
                                                          itemBuilder: (context, index) {
                                                            return ListTile(
                                                              leading: Checkbox(
                                                                side: const BorderSide(color: BillColors.deepYellow),
                                                                value: selectedList.contains(members[index]),
                                                                activeColor: BillColors.deepYellow,
                                                                onChanged: (value) {
                                                                  vm.toggleSettledMember(members[index]);
                                                                  setState(() {
                                                                    settledByController.text = vm.settledMembers.value.isEmpty ? "" : vm.settledMembers.value.map((e) => e).toString();
                                                                  });
                                                                },
                                                              ),
                                                              title: Transform.translate(
                                                                offset: const Offset(-32, 0),
                                                                child: Center(
                                                                  child: Text(members[index]),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                vm.toggleSettledMember(members[index]);
                                                                setState(() {
                                                                  settledByController.text = vm.settledMembers.value.isEmpty ? "" : vm.settledMembers.value.map((e) => e).toString();
                                                                });
                                                              },
                                                            );
                                                          },
                                                          separatorBuilder: (BuildContext context, int index) {
                                                            return const Divider(
                                                              height: 1,
                                                              color: Color(0xffECECEC),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                          );
                                        },
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          suffixIcon: const Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            color: Color(0xffAAAAAA),
                                          ),
                                          hintText: "Settled By",
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
                                }),
                            Container(
                              padding: const EdgeInsets.fromLTRB(12, 64, 12, 32),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: BillColors.lightYellow,
                                        elevation: 4,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextGetter.bodyText1?.copyWith(color: BillColors.contentTextColor),
                                      ),
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(4)),
                                  Provider(
                                    create: (context) => BillHomeViewModel(),
                                    child: Consumer<BillHomeViewModel>(
                                      builder: (context, viewModel, child) {
                                        return Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: BillColors.deepYellow,
                                              elevation: 4,
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                            ),
                                            onPressed: () async {
                                              if (formKey.currentState?.validate() == true) {
                                                double money = double.parse(amountController.text.replaceFirst("\$", ""));
                                                money = double.parse(money.toStringAsFixed(0));
                                                final result = await vm.addBill(tableId: widget.tableId, title: titleController.text, money: money, paidBy: paidByController.text);
                                                if (result.isSuccess) {
                                                  // ignore: use_build_context_synchronously
                                                  ShowSnackBarHelper.successSnackBar(context: context).showSnackbar("New Bill Success");
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop(true);
                                                } else {
                                                  // ignore: use_build_context_synchronously
                                                  ShowSnackBarHelper.errorSnackBar(context: context).showSnackbar(result.errorMessage ?? "");
                                                }
                                              }
                                            },
                                            child: Text(
                                              "Add",
                                              style: TextGetter.bodyText1?.copyWith(color: Colors.white),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
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
        }));
  }
}
