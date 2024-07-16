import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:split_bill/config/router.gr.dart';
import 'package:split_bill/core/ui/color.dart';
import 'package:split_bill/core/ui/textstyle.dart';
import 'package:split_bill/feature/newgroup/ui/new_group_page.dart';

@RoutePage()
class BillHomePage extends StatefulWidget {
  const BillHomePage({super.key});

  @override
  State<BillHomePage> createState() => _BillHomePageState();
}

class _BillHomePageState extends State<BillHomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BillColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: BillColors.backgroundColor,
        title: Text(
          "Split Bill",
          style: TextGetter.headline6?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
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
                      color: BillColors.deepYellow,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  child: Text(
                    "Tokyo",
                    style: TextGetter.botton?.copyWith(color: Colors.white),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xffAAAAAA),
                    ),
                    onPressed: () {
                      AutoRouter.of(context).push(const NewGroupRoute());
                    },
                  ),
                ),
              ],
            ),
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
                      offset: const Offset(0, 4))
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      "Overview",
                      style: TextGetter.botton?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: BillColors.lightYellow,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("????"),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: BillColors.sectionTitleColor),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      "Bills Detail",
                      style: TextGetter.botton?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: BillColors.lightYellow,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("????"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Center(
      //   child: Image.asset(
      //     width: 302,
      //     height: 302,
      //     "image/ellipse.png",
      //   ),
      // ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 88),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 4,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 29),
                backgroundColor: BillColors.deepYellow),
            onPressed: () {
              AutoRouter.of(context).push(const InitGroupRoute());
            },
            child: Text(
              "Create A New Group",
              style: TextGetter.headline6?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
