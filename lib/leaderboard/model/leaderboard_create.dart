import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';

part 'leaderboard_create.g.dart';

@JsonSerializable()
class LeaderboardCreate extends ValueObject {
  final String name;
  final String iconName;
  final Set<String> memberIds;
  final Set<String> bannedMemberIds;
  final String inviteCode;

  LeaderboardCreate({
    required this.name,
    required this.iconName,
    required this.memberIds,
    this.bannedMemberIds = const {},
    required this.inviteCode,
  });

  @override
  Map<String, dynamic> toJson() => _$LeaderboardCreateToJson(this);
}
