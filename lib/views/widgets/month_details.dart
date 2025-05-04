import 'package:flutter/material.dart';
import 'package:hammyon/viewmodela/my_view_model.dart';
import 'package:hammyon/views/widgets/my_dialog.dart';
import 'package:provider/provider.dart';

class MonthDetails extends StatefulWidget {
  const MonthDetails({super.key});

  @override
  State<MonthDetails> createState() => _MonthDetailsState();
}

class _MonthDetailsState extends State<MonthDetails> {
  String formatNumber(int number) {
    String numberStr = number.toString();
    String result = "";

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

  late final MyViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = context.read<MyViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 460,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: viewModel.notes.length,
        itemBuilder: (context, index) {
          final note = viewModel.notes[index];
          String mth = note.date.month.toString();
          mth = mth.padLeft(2, "0");
          String newPrice = formatNumber(note.sum);
          return ListTile(
            onLongPress: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await viewModel.deleteNote(note.id);
                              viewModel.refrash();
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "O'chirish",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          FilledButton(
                            onPressed: () async {
                              final res = await showDialog(
                                context: context,
                                builder: (ctx) {
                                  return MyDialog(eskiReja: note);
                                },
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                              if (res == true) {
                                viewModel.refrash();
                              }
                            },
                            child: Text("Tahrirlash"),
                          ),
                        ],
                      ),
                    ),
              );
            },
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${note.date.day}.$mth.${note.date.year}",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            trailing: Text("$newPrice so'm", style: TextStyle(fontSize: 16)),
          );
        },
      ),
    );
  }
}
