import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_bill/config/router.gr.dart';
import 'package:split_bill/core/ui/color.dart';
import 'package:split_bill/core/ui/textstyle.dart';

@RoutePage()
class InitGroupPage extends StatefulWidget {
  const InitGroupPage({super.key});

  @override
  State<InitGroupPage> createState() => _InitGroupPageState();
}

class _InitGroupPageState extends State<InitGroupPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BillColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: BillColors.backgroundColor,
        title: Text(
          "Split Bill",
          style: TextGetter.headline6
              ?.copyWith(
              color: BillColors.contentTextColor, fontWeight: FontWeight.w700),
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
                )),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(56.5, 0, 56.5, 32),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: BillColors.deepYellow,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 10)),
                  onPressed: controller.text.isEmpty
                      ? null
                      : () {
                          AutoRouter.of(context).push(
                              InitMemberRoute(billTitle: controller.text));
                        },
                  child: Text(
                    "Submit to start",
                    style: TextGetter.headline6?.copyWith(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
