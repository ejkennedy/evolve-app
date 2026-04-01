// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      onboardingData: json['onboardingData'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      preferredTheme: json['preferredTheme'] as String? ?? 'system',
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'onboardingComplete': instance.onboardingComplete,
      'onboardingData': instance.onboardingData,
      'createdAt': instance.createdAt.toIso8601String(),
      'preferredTheme': instance.preferredTheme,
    };
