// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BadgeProgress _$BadgeProgressFromJson(Map<String, dynamic> json) =>
    BadgeProgress(
      badgeId: json['badgeId'] as String,
      progress: (json['progress'] as num?)?.toInt(),
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
    );

Map<String, dynamic> _$BadgeProgressToJson(BadgeProgress instance) =>
    <String, dynamic>{
      'badgeId': instance.badgeId,
      'progress': instance.progress,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
    };
