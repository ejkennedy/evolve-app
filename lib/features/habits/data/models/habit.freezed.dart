// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Habit _$HabitFromJson(Map<String, dynamic> json) {
  return _Habit.fromJson(json);
}

/// @nodoc
mixin _$Habit {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  HabitFrequency get frequency => throw _privateConstructorUsedError;
  List<int> get targetDays => throw _privateConstructorUsedError;
  int get targetCount => throw _privateConstructorUsedError;
  HabitCategory get category => throw _privateConstructorUsedError;
  String? get linkedGoalId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  String? get iconEmoji => throw _privateConstructorUsedError;
  int? get colorValue => throw _privateConstructorUsedError;

  /// Serializes this Habit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitCopyWith<Habit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitCopyWith<$Res> {
  factory $HabitCopyWith(Habit value, $Res Function(Habit) then) =
      _$HabitCopyWithImpl<$Res, Habit>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      HabitFrequency frequency,
      List<int> targetDays,
      int targetCount,
      HabitCategory category,
      String? linkedGoalId,
      DateTime createdAt,
      bool isActive,
      int currentStreak,
      int longestStreak,
      String? iconEmoji,
      int? colorValue});
}

/// @nodoc
class _$HabitCopyWithImpl<$Res, $Val extends Habit>
    implements $HabitCopyWith<$Res> {
  _$HabitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? frequency = null,
    Object? targetDays = null,
    Object? targetCount = null,
    Object? category = null,
    Object? linkedGoalId = freezed,
    Object? createdAt = null,
    Object? isActive = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? iconEmoji = freezed,
    Object? colorValue = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as HabitFrequency,
      targetDays: null == targetDays
          ? _value.targetDays
          : targetDays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as HabitCategory,
      linkedGoalId: freezed == linkedGoalId
          ? _value.linkedGoalId
          : linkedGoalId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      iconEmoji: freezed == iconEmoji
          ? _value.iconEmoji
          : iconEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      colorValue: freezed == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HabitImplCopyWith<$Res> implements $HabitCopyWith<$Res> {
  factory _$$HabitImplCopyWith(
          _$HabitImpl value, $Res Function(_$HabitImpl) then) =
      __$$HabitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      HabitFrequency frequency,
      List<int> targetDays,
      int targetCount,
      HabitCategory category,
      String? linkedGoalId,
      DateTime createdAt,
      bool isActive,
      int currentStreak,
      int longestStreak,
      String? iconEmoji,
      int? colorValue});
}

/// @nodoc
class __$$HabitImplCopyWithImpl<$Res>
    extends _$HabitCopyWithImpl<$Res, _$HabitImpl>
    implements _$$HabitImplCopyWith<$Res> {
  __$$HabitImplCopyWithImpl(
      _$HabitImpl _value, $Res Function(_$HabitImpl) _then)
      : super(_value, _then);

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? frequency = null,
    Object? targetDays = null,
    Object? targetCount = null,
    Object? category = null,
    Object? linkedGoalId = freezed,
    Object? createdAt = null,
    Object? isActive = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? iconEmoji = freezed,
    Object? colorValue = freezed,
  }) {
    return _then(_$HabitImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as HabitFrequency,
      targetDays: null == targetDays
          ? _value._targetDays
          : targetDays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as HabitCategory,
      linkedGoalId: freezed == linkedGoalId
          ? _value.linkedGoalId
          : linkedGoalId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      iconEmoji: freezed == iconEmoji
          ? _value.iconEmoji
          : iconEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      colorValue: freezed == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitImpl implements _Habit {
  const _$HabitImpl(
      {required this.id,
      required this.userId,
      required this.title,
      this.description,
      this.frequency = HabitFrequency.daily,
      final List<int> targetDays = const [],
      this.targetCount = 1,
      this.category = HabitCategory.other,
      this.linkedGoalId,
      required this.createdAt,
      this.isActive = true,
      this.currentStreak = 0,
      this.longestStreak = 0,
      this.iconEmoji,
      this.colorValue})
      : _targetDays = targetDays;

  factory _$HabitImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final HabitFrequency frequency;
  final List<int> _targetDays;
  @override
  @JsonKey()
  List<int> get targetDays {
    if (_targetDays is EqualUnmodifiableListView) return _targetDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetDays);
  }

  @override
  @JsonKey()
  final int targetCount;
  @override
  @JsonKey()
  final HabitCategory category;
  @override
  final String? linkedGoalId;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  final String? iconEmoji;
  @override
  final int? colorValue;

  @override
  String toString() {
    return 'Habit(id: $id, userId: $userId, title: $title, description: $description, frequency: $frequency, targetDays: $targetDays, targetCount: $targetCount, category: $category, linkedGoalId: $linkedGoalId, createdAt: $createdAt, isActive: $isActive, currentStreak: $currentStreak, longestStreak: $longestStreak, iconEmoji: $iconEmoji, colorValue: $colorValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality()
                .equals(other._targetDays, _targetDays) &&
            (identical(other.targetCount, targetCount) ||
                other.targetCount == targetCount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.linkedGoalId, linkedGoalId) ||
                other.linkedGoalId == linkedGoalId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.iconEmoji, iconEmoji) ||
                other.iconEmoji == iconEmoji) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      description,
      frequency,
      const DeepCollectionEquality().hash(_targetDays),
      targetCount,
      category,
      linkedGoalId,
      createdAt,
      isActive,
      currentStreak,
      longestStreak,
      iconEmoji,
      colorValue);

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      __$$HabitImplCopyWithImpl<_$HabitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitImplToJson(
      this,
    );
  }
}

abstract class _Habit implements Habit {
  const factory _Habit(
      {required final String id,
      required final String userId,
      required final String title,
      final String? description,
      final HabitFrequency frequency,
      final List<int> targetDays,
      final int targetCount,
      final HabitCategory category,
      final String? linkedGoalId,
      required final DateTime createdAt,
      final bool isActive,
      final int currentStreak,
      final int longestStreak,
      final String? iconEmoji,
      final int? colorValue}) = _$HabitImpl;

  factory _Habit.fromJson(Map<String, dynamic> json) = _$HabitImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  HabitFrequency get frequency;
  @override
  List<int> get targetDays;
  @override
  int get targetCount;
  @override
  HabitCategory get category;
  @override
  String? get linkedGoalId;
  @override
  DateTime get createdAt;
  @override
  bool get isActive;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  String? get iconEmoji;
  @override
  int? get colorValue;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
