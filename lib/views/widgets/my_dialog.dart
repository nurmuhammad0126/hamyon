import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hammyon/models/my_model.dart';
import 'package:hammyon/viewmodela/my_view_model.dart';

class MyDialog extends StatefulWidget {
  final MyModel? eskiReja;
  const MyDialog({super.key, this.eskiReja});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final todosViewmodel = MyViewModel();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _sumController = TextEditingController();
  bool _isLoading = false;

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
  void initState() {
    super.initState();

    if (widget.eskiReja != null) {
      _nameController.text = widget.eskiReja!.title;
      _dateController.text = widget.eskiReja!.date.toString();
      _sumController.text = formatNumber(widget.eskiReja!.sum);
    }
  }

  void showCalendar() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(1),
      lastDate: DateTime(3000),
    );

    if (result != null) {
      _dateController.text = result.toString();
    }
  }

  void save() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final title = _nameController.text;
      final date = DateTime.parse(_dateController.text);
      final sum = _sumController.text.replaceAll('.', '');

      if (widget.eskiReja == null) {
        await todosViewmodel.addNote(
          title: title,
          date: date,
          sum: int.parse(sum),
        );
      } else {
        final updatedTodo = widget.eskiReja!.copyWith(
          title: title,
          date: date,
          sum: int.parse(sum),
        );
        await todosViewmodel.editNote(updatedTodo);
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _sumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.eskiReja == null ? "Harajat qo'shish" : "Reja o'zgartirish",
      ),
      content: Form(
        key: _formKey,
        child: Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nomi",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Iltimos reja nomini kiriting";
                }
                if (value.length < 2) {
                  return "Iltimos batafsil reja kiriting";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _sumController,
              inputFormatters: [ThousandsSeparatorInputFormatter()],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "summa",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Iltimos summani kiriting";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () {
                showCalendar();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Kuni",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Iltimos reja kunini kiriting";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed:
              _isLoading
                  ? () {}
                  : () {
                    Navigator.pop(context, true);
                  },
          child: Text("Bekor Qilish"),
        ),
        FilledButton(
          onPressed: _isLoading ? () {} : save,
          child:
              _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Saqlash"),
        ),
      ],
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
