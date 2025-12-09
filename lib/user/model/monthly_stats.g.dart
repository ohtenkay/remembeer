// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyStats _$MonthlyStatsFromJson(Map<String, dynamic> json) => MonthlyStats(
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  beersConsumed: (json['beersConsumed'] as num).toDouble(),
  alcoholConsumedMl: (json['alcoholConsumedMl'] as num).toDouble(),
);

Map<String, dynamic> _$MonthlyStatsToJson(MonthlyStats instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'beersConsumed': instance.beersConsumed,
      'alcoholConsumedMl': instance.alcoholConsumedMl,
    };
