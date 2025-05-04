
class MyModel {
  int? id;
  DateTime date;
  String title;
  int sum;
  MyModel({
    required this.date,
    required this.sum,
    required this.title,
    this.id,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      date: DateTime.parse(json["date"]),
      sum: json["sum"],
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"date": date.toString(), "title": title, "sum": sum};
  }

  MyModel copyWith({int? id, String? title, DateTime? date, int? sum}) {
    return MyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      sum: sum ?? this.sum,
    );
  }
}
