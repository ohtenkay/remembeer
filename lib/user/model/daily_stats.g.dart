// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyStats _$DailyStatsFromJson(Map<String, dynamic> json) => DailyStats(
  day: (json['day'] as num).toInt(),
  beersConsumed: (json['beersConsumed'] as num).toDouble(),
  alcoholConsumedMl: (json['alcoholConsumedMl'] as num).toDouble(),
);

Map<String, dynamic> _$DailyStatsToJson(DailyStats instance) =>
    <String, dynamic>{
      'day': instance.day,
      'beersConsumed': instance.beersConsumed,
      'alcoholConsumedMl': instance.alcoholConsumedMl,
    };
