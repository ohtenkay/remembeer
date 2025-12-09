// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardCreate _$LeaderboardCreateFromJson(Map<String, dynamic> json) =>
    LeaderboardCreate(
      name: json['name'] as String,
      memberIds: (json['memberIds'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      bannedMemberIds:
          (json['bannedMemberIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      inviteCode: json['inviteCode'] as String,
    );

Map<String, dynamic> _$LeaderboardCreateToJson(LeaderboardCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'memberIds': instance.memberIds.toList(),
      'bannedMemberIds': instance.bannedMemberIds.toList(),
      'inviteCode': instance.inviteCode,
    };
