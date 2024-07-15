import 'package:flutter/material.dart';
import 'package:split_bill/core/ui/color.dart';
import 'package:split_bill/core/ui/textstyle.dart';

class BillHomePage extends StatefulWidget {
  const BillHomePage({super.key});

  @override
  State<BillHomePage> createState() => _BillHomePageState();
}

class _BillHomePageState extends State<BillHomePage> {
  @override
  Widget build(BuildContext context) {
    ;

    return Scaffold(
      backgroundColor: BillColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Split Bill",
          style: TextGetter.headline6?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Image.asset(
          width: 302,
          height: 302,
          "image/ellipse.png",
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 88),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 4,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 29),
                backgroundColor: BillColors.buttonBgColor),
            onPressed: () {},
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
