import 'package:flutter/material.dart';
import 'package:hammyon/viewmodela/my_view_model.dart';
import 'package:provider/provider.dart';

class TotalPrice extends StatelessWidget {
  const TotalPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 11, 53, 50),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 2,
          color: const Color.fromARGB(255, 0, 255, 230),
        ),
      ),
      child: Center(
        child: Consumer<MyViewModel>(
          builder: (_, value, __) {
            return RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value.formatNumber(value.totalSumm),
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      color: const Color.fromARGB(255, 0, 255, 230),
                    ),
                  ),
                  TextSpan(
                    text: " so'm",
                    style: TextStyle(
                      fontSize: 25,
                      color: const Color.fromARGB(255, 0, 255, 230),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
