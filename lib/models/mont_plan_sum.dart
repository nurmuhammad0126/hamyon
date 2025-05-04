class MontPlanSum {
  final int? id;
  final int month;
  final int year;
  final int planAmount;

  MontPlanSum({
    this.id,
    required this.month,
    required this.year,
    required this.planAmount,
  });

  Map<String, dynamic> toJson() {
    return {"id": id, "month": month, "year": year, "planAmount": planAmount};
  }

  factory MontPlanSum.fromJson(Map<String, dynamic> json) {
    return MontPlanSum(
      month: json["month"],
      year: json["year"],
      planAmount: json["planAmount"],
    );
  }
}
