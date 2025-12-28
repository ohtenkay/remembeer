import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'daily_stats.g.dart';

@JsonSerializable()
class DailyStats {
  final int day;
  final double beersConsumed;
  final double alcoholConsumedMl;

  const DailyStats({
    required this.day,
    required this.beersConsumed,
    required this.alcoholConsumedMl,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DailyStatsToJson(this);

  DailyStats addDrink({
    required double beersEquivalent,
    required double alcoholMl,
  }) {
    return copyWith(
      beersConsumed: beersConsumed + beersEquivalent,
      alcoholConsumedMl: alcoholConsumedMl + alcoholMl,
    );
  }

  DailyStats removeDrink({
    required double beersEquivalent,
    required double alcoholMl,
  }) {
    return copyWith(
      beersConsumed: max(0, beersConsumed - beersEquivalent),
      alcoholConsumedMl: max(0, alcoholConsumedMl - alcoholMl),
    );
  }

  DailyStats copyWith({double? beersConsumed, double? alcoholConsumedMl}) {
    return DailyStats(
      day: day,
      beersConsumed: beersConsumed ?? this.beersConsumed,
      alcoholConsumedMl: alcoholConsumedMl ?? this.alcoholConsumedMl,
    );
  }
}
