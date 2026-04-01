// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitImpl _$$HabitImplFromJson(Map<String, dynamic> json) => _$HabitImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      frequency:
          $enumDecodeNullable(_$HabitFrequencyEnumMap, json['frequency']) ??
              HabitFrequency.daily,
      targetDays: (json['targetDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      targetCount: (json['targetCount'] as num?)?.toInt() ?? 1,
      category: $enumDecodeNullable(_$HabitCategoryEnumMap, json['category']) ??
          HabitCategory.other,
      linkedGoalId: json['linkedGoalId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      iconEmoji: json['iconEmoji'] as String?,
      colorValue: (json['colorValue'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$HabitImplToJson(_$HabitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'frequency': _$HabitFrequencyEnumMap[instance.frequency]!,
      'targetDays': instance.targetDays,
      'targetCount': instance.targetCount,
      'category': _$HabitCategoryEnumMap[instance.category]!,
      'linkedGoalId': instance.linkedGoalId,
      'createdAt': instance.createdAt.toIso8601String(),
      'isActive': instance.isActive,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'iconEmoji': instance.iconEmoji,
      'colorValue': instance.colorValue,
    };

const _$HabitFrequencyEnumMap = {
  HabitFrequency.daily: 'daily',
  HabitFrequency.weekdays: 'weekdays',
  HabitFrequency.weekends: 'weekends',
  HabitFrequency.custom: 'custom',
};

const _$HabitCategoryEnumMap = {
  HabitCategory.health: 'health',
  HabitCategory.mindfulness: 'mindfulness',
  HabitCategory.learning: 'learning',
  HabitCategory.productivity: 'productivity',
  HabitCategory.social: 'social',
  HabitCategory.other: 'other',
};
