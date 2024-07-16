import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_bill/core/ui/color.dart';
import 'package:split_bill/core/ui/textstyle.dart';

@RoutePage()
class InitMemberPage extends StatefulWidget {
  const InitMemberPage({super.key});

  @override
  State<InitMemberPage> createState() => _InitMemberPageState();
}

class _InitMemberPageState extends State<InitMemberPage> {
  TextEditingController controller = TextEditingController();
  List<String> members = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BillColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: BillColors.backgroundColor,
        title: Text(
          "Split Bill",
          style: TextGetter.headline6
              ?.copyWith(color: BillColors.contentTextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 1,
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(32, 32, 32, 0),
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
                            LengthLimitingTextInputFormatter(30)
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(56.5, 64, 56.5, 24),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: BillColors.deepYellow,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 48, vertical: 10)),
                        onPressed: controller.text.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  members.add(controller.text);
                                  controller.text = "";
                                });
                                // AutoRouter.of(context).push(route);
                              },
                        child: Text(
                          "Add",
                          style: TextGetter.headline6
                              ?.copyWith(color: Colors.white),
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(56.5, 0, 56.5, 32),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: BillColors.lightYellow,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 48, vertical: 10)),
                        onPressed: () {
                          Navigator.of(context).pop;
                        },
                        child: Text(
                          "Back",
                          style: TextGetter.headline6
                              ?.copyWith(color: BillColors.contentTextColor),
                        )),
                  ),
                ],
              ),
            ),
            members.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Members",
                          style: TextGetter.botton?.copyWith(
                              color: BillColors.contentTextColor,
                              fontWeight: FontWeight.w700),
                        ),
                        const Padding(padding: EdgeInsets.all(4)),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    spreadRadius: 1,
                                    blurRadius: 12,
                                    offset: const Offset(0, 4))
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.fromLTRB(12, 24, 12, 0),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: BillColors.lightYellow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Text(members[index]),
                                    const Spacer(),
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            setState(() {
                                              members.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(Icons.clear)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: members.length,
                          ),
                        ),
                      ],
                    ),
                  ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 114, 0, 0)),
            members.length >= 2
                ? Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 56),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 88),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          elevation: 6, backgroundColor: BillColors.deepYellow),
                      child: Text(
                        "Start",
                        style:
                            TextGetter.headline6?.copyWith(color: Colors.white),
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
