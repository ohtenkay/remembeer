import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/entity.dart';

part 'session.g.dart';

@JsonSerializable()
class Session extends Entity {
  final DateTime startedAt;
  final DateTime? endedAt;
  final Set<String> memberIds;

  const Session({
    required super.id,
    required super.userId,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    required this.startedAt,
    this.endedAt,
    required this.memberIds,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  Session copyWith({
    DateTime? startedAt,
    DateTime? endedAt,
    Set<String>? memberIds,
  }) {
    return Session(
      id: id,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,

      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      memberIds: memberIds ?? this.memberIds,
    );
  }
}
