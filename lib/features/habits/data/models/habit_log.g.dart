// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitLogImpl _$$HabitLogImplFromJson(Map<String, dynamic> json) =>
    _$HabitLogImpl(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      userId: json['userId'] as String,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      count: (json['count'] as num?)?.toInt() ?? 1,
      note: json['note'] as String?,
      synced: json['synced'] as bool? ?? false,
    );

Map<String, dynamic> _$$HabitLogImplToJson(_$HabitLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'habitId': instance.habitId,
      'userId': instance.userId,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'count': instance.count,
      'note': instance.note,
      'synced': instance.synced,
    };
