// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Leaderboard _$LeaderboardFromJson(Map<String, dynamic> json) => Leaderboard(
  id: json['id'] as String,
  userId: json['userId'] as String,
  createdAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['createdAt'],
    const TimestampConverter().fromJson,
  ),
  updatedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['updatedAt'],
    const TimestampConverter().fromJson,
  ),
  deletedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['deletedAt'],
    const TimestampConverter().fromJson,
  ),
  name: json['name'] as String,
  memberIds: (json['memberIds'] as List<dynamic>)
      .map((e) => e as String)
      .toSet(),
  bannedMemberIds: (json['bannedMemberIds'] as List<dynamic>)
      .map((e) => e as String)
      .toSet(),
  inviteCode: json['inviteCode'] as String,
);

Map<String, dynamic> _$LeaderboardToJson(Leaderboard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'createdAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.createdAt,
        const TimestampConverter().toJson,
      ),
      'updatedAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.updatedAt,
        const TimestampConverter().toJson,
      ),
      'deletedAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.deletedAt,
        const TimestampConverter().toJson,
      ),
      'name': instance.name,
      'memberIds': instance.memberIds.toList(),
      'bannedMemberIds': instance.bannedMemberIds.toList(),
      'inviteCode': instance.inviteCode,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
