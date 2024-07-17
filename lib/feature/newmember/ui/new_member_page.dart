import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:split_bill/core/ui/color.dart';
import 'package:split_bill/core/ui/show_snack_bar.dart';
import 'package:split_bill/core/ui/textstyle.dart';
import 'package:split_bill/feature/newmember/domain/new_member_view_model.dart';

@RoutePage()
class NewMemberPage extends StatefulWidget {
  const NewMemberPage({super.key, required this.tableId});

  final int tableId;

  @override
  State<NewMemberPage> createState() => _NewMemberPageState();
}

class _NewMemberPageState extends State<NewMemberPage> {
  late NewMemberViewModel newMemberViewModel;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    newMemberViewModel = NewMemberViewModel();
    print(widget.tableId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<NewMemberViewModel>(
      create: (context) => newMemberViewModel,
      builder: (context, child) {
        return Consumer<NewMemberViewModel>(
          builder: (context, vm, child) {
            return Scaffold(
              backgroundColor: BillColors.backgroundColor,
              appBar: AppBar(
                backgroundColor: BillColors.backgroundColor,
                title: Text(
                  "New Member",
                  style: TextGetter.headline6?.copyWith(
                      color: BillColors.contentTextColor,
                      fontWeight: FontWeight.w700),
                ),
              ),
              body: Container(
                height: 205,
                margin: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 1,
                        blurRadius: 12,
                        offset: const Offset(0, 4))
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
                            onChanged: (value) {
                              setState(() {
                                controller.text = value;
                              });
                            },
                            controller: controller,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20)
                            ],
                            decoration: InputDecoration(
                                hintText: "Enter A Member Name",
                                hintStyle: TextGetter.bodyText1
                                    ?.copyWith(color: const Color(0xffAAAAAA)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 7.5),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                        )),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: BillColors.lightYellow,
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 53, vertical: 10)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                                style: TextGetter.bodyText1?.copyWith(
                                    color: BillColors.contentTextColor),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(4)),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: BillColors.deepYellow,
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 53, vertical: 10)),
                              onPressed: controller.text.isEmpty
                                  ? null
                                  : () async {
                                      await vm.addMember(
                                          widget.tableId, controller.text);

                                      if (vm.result != null) {
                                        if (vm.result!.isSuccess) {
                                          ShowSnackBarHelper.successSnackBar(
                                                  context: context)
                                              .showSnackbar(
                                                  "Member added successfully.");
                                        } else {
                                          ShowSnackBarHelper.errorSnackBar(
                                                  context: context)
                                              .showSnackbar(
                                                  vm.result!.errorMessags ??
                                                      "");
                                        }
                                      }
                                    },
                              child: Text(
                                "Add",
                                style: TextGetter.bodyText1
                                    ?.copyWith(color: Colors.white),
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
      },
    );
  }
}
