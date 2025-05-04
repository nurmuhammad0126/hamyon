import 'package:flutter/material.dart';
import 'package:hammyon/viewmodela/my_view_model.dart';
import 'package:provider/provider.dart';

class PlanIndicator extends StatefulWidget {
  final String planSumm;
  final double pracent;
  final Widget alert;
  const PlanIndicator({
    required this.pracent,
    required this.planSumm,
    required this.alert,
    super.key,
  });

  @override
  State<PlanIndicator> createState() => _PlanIndicatorState();
}

class _PlanIndicatorState extends State<PlanIndicator> {
  final planController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 58, 57, 57),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return widget.alert;
                      },
                    );
                  },
                  child: Consumer<MyViewModel>(
                    builder: (_, value, __) {
                      return Text(
                        "${value.formatNumber(value.planSumm)} so'm",
                        style: TextStyle(fontSize: 17),
                      );
                    },
                  ),
                ),
                Consumer<MyViewModel>(
                  builder: (_, value, __) {
                    return Text(
                      "${(value.pracent * 100).toInt()}.0 %",
                      style: TextStyle(fontSize: 17),
                    );
                  },
                ),
              ],
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Consumer<MyViewModel>(
                builder: (_, value, __) {
                  return FractionallySizedBox(
                    alignment: Alignment(-1, -1),
                    widthFactor: value.pracent,
                    child: Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 255, 68),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
