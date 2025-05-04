import 'package:flutter/material.dart';
import 'package:hammyon/models/my_model.dart';
import 'package:hammyon/services/local_database.dart';

class MyViewModel extends ChangeNotifier {
  MyViewModel._();

  static final _private = MyViewModel._();

  factory MyViewModel() => _private;

  int totalSumm = 0;
  int planSumm = 500000;
  double pracent = 0;
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  String newTotalSum = "";
  String newPlanAmount = "";
  final List<Color> colors = [
    Colors.orange,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.pink,
  ];

  void filterMonth({bool? where}) {
    if (where == null) {
      month = 1;
    } else if (where == true) {
      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
    } else if (where == false) {
      month--;
      if (month < 1) {
        month = 12;
        year--;
      }
    }
    refrash();
  }

  void refrash() async {
    if (month > 12) {
      month = 1;
      year++;
    } else if (month < 1) {
      month = 12;
      year--;
    }
    planSumm = await getMonthlyPlan(month: month, year: year);
    totalSumm = 0;
    await getNotes(month: month);
    for (var n in notes) {
      totalSumm += n.sum;
    }
    pracent = totalSumm / planSumm;
    notifyListeners();
  }

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

  final _localDatabase = LocalDatabase();
  List<MyModel> notes = [];

  Future<void> getNotes({required int month}) async {
    notes = await _localDatabase.get(month: month);
  }

  Future<void> addNote({
    required String title,
    required DateTime date,
    required int sum,
  }) async {
    try {
      final newNote = MyModel(date: date, sum: sum, title: title);
      final id = await _localDatabase.insert(newNote);
      if (id != null) {
        notes.add(newNote.copyWith(id: id));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> editNote(MyModel note) async {
    try {
      await _localDatabase.update(note);
      final currentIndex = notes.indexWhere((t) => t.id == note.id);
      if (currentIndex != -1) {
        notes[currentIndex] = note;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteNote(int? id) async {
    try {
      await _localDatabase.delete(id ?? -1);
      notes.removeWhere((t) => t.id == id);
    } catch (e) {
      print(e);
    }
  }

  Future<int> getMonthlyPlan({required int month, required int year}) async {
    try {
      return await _localDatabase.getMonthlyPlan(month: month, year: year);
    } catch (e) {
      print(e);
      return 50000;
    }
  }

  Future<void> saveMonthlyPlan({
    required int month,
    required int year,
    required int planAmount,
  }) async {
    try {
      await _localDatabase.saveMonthlyPlan(
        month: month,
        year: year,
        planAmount: planAmount,
      );
    } catch (e) {
      print(e);
    }
  }
}
