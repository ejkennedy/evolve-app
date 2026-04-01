// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: $enumDecodeNullable(_$GoalCategoryEnumMap, json['category']) ??
          GoalCategory.personal,
      status: $enumDecodeNullable(_$GoalStatusEnumMap, json['status']) ??
          GoalStatus.active,
      targetValue: (json['targetValue'] as num?)?.toDouble() ?? 0.0,
      currentValue: (json['currentValue'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? '',
      targetDate: DateTime.parse(json['targetDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      aiInsight: json['aiInsight'] as String?,
    );

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'category': _$GoalCategoryEnumMap[instance.category]!,
      'status': _$GoalStatusEnumMap[instance.status]!,
      'targetValue': instance.targetValue,
      'currentValue': instance.currentValue,
      'unit': instance.unit,
      'targetDate': instance.targetDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'tags': instance.tags,
      'aiInsight': instance.aiInsight,
    };

const _$GoalCategoryEnumMap = {
  GoalCategory.health: 'health',
  GoalCategory.career: 'career',
  GoalCategory.relationships: 'relationships',
  GoalCategory.finance: 'finance',
  GoalCategory.personal: 'personal',
};

const _$GoalStatusEnumMap = {
  GoalStatus.active: 'active',
  GoalStatus.paused: 'paused',
  GoalStatus.completed: 'completed',
  GoalStatus.abandoned: 'abandoned',
};
