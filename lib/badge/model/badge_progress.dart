import 'package:json_annotation/json_annotation.dart';

part 'badge_progress.g.dart';

@JsonSerializable()
class BadgeProgress {
  final String badgeId;
  final int? progress;
  final DateTime? unlockedAt;

  const BadgeProgress({required this.badgeId, this.progress, this.unlockedAt});

  factory BadgeProgress.fromJson(Map<String, dynamic> json) =>
      _$BadgeProgressFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeProgressToJson(this);
}
