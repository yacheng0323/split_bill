import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_bill/config/router.gr.dart';
import 'package:split_bill/core/ui/color.dart';
import 'package:split_bill/core/ui/textstyle.dart';

@RoutePage()
class NewGroupPage extends StatefulWidget {
  const NewGroupPage({super.key});

  @override
  State<NewGroupPage> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController memberNameController = TextEditingController();
  List<String> members = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BillColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: BillColors.backgroundColor,
        title: Text(
          "New Group",
          style: TextGetter.headline6?.copyWith(
              color: BillColors.contentTextColor, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(32, 32, 0, 0),
              child: Text(
                "Group Name",
                style: TextGetter.botton?.copyWith(
                    color: BillColors.contentTextColor,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(32, 8, 32, 0),
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
                    padding: const EdgeInsets.fromLTRB(12, 32, 12, 32),
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
                            groupNameController.text = value;
                          });
                        },
                        controller: groupNameController,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        decoration: InputDecoration(
                            hintText: "Enter A Group Name",
                            hintStyle: TextGetter.bodyText1
                                ?.copyWith(color: const Color(0xffAAAAAA)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7.5),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(32, 24, 0, 0),
              child: Text(
                "Members",
                style: TextGetter.botton?.copyWith(
                    color: BillColors.contentTextColor,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(32, 8, 32, 0),
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
                            memberNameController.text = value;
                          });
                        },
                        controller: memberNameController,
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
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
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.fromLTRB(0, 8, 12, 32),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 4),
                          backgroundColor: BillColors.deepYellow,
                          elevation: 4),
                      onPressed: memberNameController.text.isEmpty
                          ? null
                          : () {
                              setState(() {
                                members.add(memberNameController.text);
                                memberNameController.text = "";
                              });
                            },
                      child: Text(
                        "Add",
                        style:
                            TextGetter.headline6?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  //* List member
                  Container(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
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
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 56),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 53, vertical: 10),
                    backgroundColor: BillColors.lightYellow,
                    elevation: 4),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextGetter.headline6
                      ?.copyWith(color: BillColors.contentTextColor),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(4)),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 53, vertical: 10),
                    backgroundColor: BillColors.deepYellow,
                    elevation: 4),
                onPressed:
                    (members.length >= 2 && groupNameController.text.isNotEmpty)
                        ? () {}
                        : null,
                child: Text(
                  "Submit",
                  style: TextGetter.headline6?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
