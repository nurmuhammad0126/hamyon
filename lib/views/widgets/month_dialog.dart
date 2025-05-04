import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hammyon/viewmodela/my_view_model.dart';
import 'package:provider/provider.dart';

class MonthDialog extends StatefulWidget {
  final Function refrash;
  final int month;
  final int year;
  final int planSumm;
  final TextEditingController planController;
  const MonthDialog({
    super.key,
    required this.planController,
    required this.planSumm,
    required this.month,
    required this.year,
    required this.refrash,
  });

  @override
  State<MonthDialog> createState() => _MonthDialogState();
}

class _MonthDialogState extends State<MonthDialog> {
  int? new2PlanAmount = 0;

  String formatNumber(int number) {
    String numberStr = number.toString();
    String result = '';

    int count = 0;
    for (int i = numberStr.length - 1; i >= 0; i--) {
      result = numberStr[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = ".$result";
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller:
                widget.planController..text = formatNumber(widget.planSumm),
            decoration: InputDecoration(
              hintText: "Yangi planni kiriting",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [ThousandsSeparatorInputFormatter()],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Bekor qilish"),
              ),
              FilledButton(
                onPressed: () async {
                  new2PlanAmount =
                      int.tryParse(
                        widget.planController.text.replaceAll('.', ''),
                      ) ??
                      widget.planSumm;
                  int newPlanAmount = new2PlanAmount ?? widget.planSumm;
                  await context.read<MyViewModel>().saveMonthlyPlan(
                    month: widget.month,
                    year: widget.year,
                    planAmount: newPlanAmount,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  widget.refrash();
                },
                child: Text("O'zgartirish"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll('.', '');
    if (newText.isEmpty) return newValue;

    String formatted = '';
    int count = 0;

    for (int i = newText.length - 1; i >= 0; i--) {
      formatted = newText[i] + formatted;
      count++;
      if (count == 3 && i != 0) {
        formatted = ".$formatted";
        count = 0;
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
