import 'package:hammyon/models/my_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._instance();

  static final _private = LocalDatabase._instance();

  factory LocalDatabase() {
    return _private;
  }

  final String _tableName = "notes";
  final String _planTableName = "monthlyPlan";
  Database? _database;

  Future<void> init() async {
    _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    try {
      final databasePath = await getApplicationDocumentsDirectory();
      final path = "${databasePath.path}/notes.db";

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e, s) {
      print(e);
      print(s);
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute("""
        CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        sum INTEGER)
      """);
      await db.execute("""
        CREATE TABLE $_planTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        planAmount INTEGER NOT NULL,
        UNIQUE(month,year)
      )
      """);
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < 2) {
        await db.execute("""CREATE TABLE IF NOT EXISTS $_planTableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          month INTEGER NOT NULL,
          year INTEGER NOT NULL,
          planAmount INTEGER NOT NULL,
          UNIQUE(month, year)
        )""");
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Future<List<MyModel>> get({required int month}) async {
    String startDate = month > 9 ? "2025-$month-01" : "2025-0$month-01";
    String endDate;

    if (month == 2) {
      endDate = "2025-02-28";
    } else if ([4, 6, 9, 11].contains(month)) {
      endDate = month > 9 ? "2025-$month-30" : "2025-0$month-30";
    } else {
      endDate = month > 9 ? "2025-$month-31" : "2025-0$month-31";
    }

    final data = await _database?.query(
      _tableName,
      where: "date >= ? AND date <= ?",
      whereArgs: [startDate, endDate],
    );

    List<MyModel> notes = [];
    if (data != null) {
      for (var i in data) {
        notes.add(MyModel.fromJson(i));
      }
    }

    return notes;
  }

  Future<int?> insert(MyModel note) async {
    return await _database?.insert(_tableName, note.toJson());
  }

  Future<void> update(MyModel note) async {
    await _database?.update(
      _tableName,
      note.toJson(),
      where: "id=?",
      whereArgs: [note.id],
    );
  }

  Future<void> delete(int id) async {
    await _database?.delete(_tableName, where: "id=?", whereArgs: [id]);
  }

  Future<int> getMonthlyPlan({required int month, required int year}) async {
    final data = await _database?.query(
      _planTableName,
      where: "month = ? AND year=?",
      whereArgs: [month, year],
    );
    if (data == null || data.isEmpty) {
      return 500000;
    }
    return data.first["planAmount"] as int;
  }

  Future<int?> saveMonthlyPlan({
    required int month,
    required int year,
    required int planAmount,
  }) async {
    final existinPlan = await _database?.query(
      _planTableName,
      where: "month = ? AND year = ?",
      whereArgs: [month, year],
    );

    if (existinPlan != null && existinPlan.isNotEmpty) {
      return await _database?.update(
        _planTableName,
        {"planAmount": planAmount},
        where: "month = ? AND year = ?",
        whereArgs: [month, year],
      );
    } else {
      return await _database?.insert(_planTableName, {
        "month": month,
        "year": year,
        "planAmount": planAmount,
      });
    }
  }
}
