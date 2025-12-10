import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'monthly_stats.g.dart';

@JsonSerializable()
class MonthlyStats {
  final int year;
  final int month;
  final double beersConsumed;
  final double alcoholConsumedMl;

  const MonthlyStats({
    required this.year,
    required this.month,
    required this.beersConsumed,
    required this.alcoholConsumedMl,
  });

  factory MonthlyStats.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStatsFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyStatsToJson(this);

  String get key => '${year}_$month';

  static String keyFor(int year, int month) => '${year}_$month';

  MonthlyStats copyWith({double? beersConsumed, double? alcoholConsumedMl}) {
    return MonthlyStats(
      year: year,
      month: month,
      beersConsumed: beersConsumed ?? this.beersConsumed,
      alcoholConsumedMl: alcoholConsumedMl ?? this.alcoholConsumedMl,
    );
  }

  MonthlyStats addDrink({
    required double beersEquivalent,
    required double alcoholMl,
  }) {
    return copyWith(
      beersConsumed: beersConsumed + beersEquivalent,
      alcoholConsumedMl: alcoholConsumedMl + alcoholMl,
    );
  }

  MonthlyStats removeDrink({
    required double beersEquivalent,
    required double alcoholMl,
  }) {
    return copyWith(
      beersConsumed: max(0, beersConsumed - beersEquivalent),
      alcoholConsumedMl: max(0, alcoholConsumedMl - alcoholMl),
    );
  }
}
