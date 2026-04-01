// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HabitLog _$HabitLogFromJson(Map<String, dynamic> json) {
  return _HabitLog.fromJson(json);
}

/// @nodoc
mixin _$HabitLog {
  String get id => throw _privateConstructorUsedError;
  String get habitId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get loggedAt => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  bool get synced => throw _privateConstructorUsedError;

  /// Serializes this HabitLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HabitLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitLogCopyWith<HabitLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitLogCopyWith<$Res> {
  factory $HabitLogCopyWith(HabitLog value, $Res Function(HabitLog) then) =
      _$HabitLogCopyWithImpl<$Res, HabitLog>;
  @useResult
  $Res call(
      {String id,
      String habitId,
      String userId,
      DateTime loggedAt,
      int count,
      String? note,
      bool synced});
}

/// @nodoc
class _$HabitLogCopyWithImpl<$Res, $Val extends HabitLog>
    implements $HabitLogCopyWith<$Res> {
  _$HabitLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? habitId = null,
    Object? userId = null,
    Object? loggedAt = null,
    Object? count = null,
    Object? note = freezed,
    Object? synced = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      habitId: null == habitId
          ? _value.habitId
          : habitId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      loggedAt: null == loggedAt
          ? _value.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HabitLogImplCopyWith<$Res>
    implements $HabitLogCopyWith<$Res> {
  factory _$$HabitLogImplCopyWith(
          _$HabitLogImpl value, $Res Function(_$HabitLogImpl) then) =
      __$$HabitLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String habitId,
      String userId,
      DateTime loggedAt,
      int count,
      String? note,
      bool synced});
}

/// @nodoc
class __$$HabitLogImplCopyWithImpl<$Res>
    extends _$HabitLogCopyWithImpl<$Res, _$HabitLogImpl>
    implements _$$HabitLogImplCopyWith<$Res> {
  __$$HabitLogImplCopyWithImpl(
      _$HabitLogImpl _value, $Res Function(_$HabitLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of HabitLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? habitId = null,
    Object? userId = null,
    Object? loggedAt = null,
    Object? count = null,
    Object? note = freezed,
    Object? synced = null,
  }) {
    return _then(_$HabitLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      habitId: null == habitId
          ? _value.habitId
          : habitId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      loggedAt: null == loggedAt
          ? _value.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitLogImpl implements _HabitLog {
  const _$HabitLogImpl(
      {required this.id,
      required this.habitId,
      required this.userId,
      required this.loggedAt,
      this.count = 1,
      this.note,
      this.synced = false});

  factory _$HabitLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitLogImplFromJson(json);

  @override
  final String id;
  @override
  final String habitId;
  @override
  final String userId;
  @override
  final DateTime loggedAt;
  @override
  @JsonKey()
  final int count;
  @override
  final String? note;
  @override
  @JsonKey()
  final bool synced;

  @override
  String toString() {
    return 'HabitLog(id: $id, habitId: $habitId, userId: $userId, loggedAt: $loggedAt, count: $count, note: $note, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.habitId, habitId) || other.habitId == habitId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.synced, synced) || other.synced == synced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, habitId, userId, loggedAt, count, note, synced);

  /// Create a copy of HabitLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitLogImplCopyWith<_$HabitLogImpl> get copyWith =>
      __$$HabitLogImplCopyWithImpl<_$HabitLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitLogImplToJson(
      this,
    );
  }
}

abstract class _HabitLog implements HabitLog {
  const factory _HabitLog(
      {required final String id,
      required final String habitId,
      required final String userId,
      required final DateTime loggedAt,
      final int count,
      final String? note,
      final bool synced}) = _$HabitLogImpl;

  factory _HabitLog.fromJson(Map<String, dynamic> json) =
      _$HabitLogImpl.fromJson;

  @override
  String get id;
  @override
  String get habitId;
  @override
  String get userId;
  @override
  DateTime get loggedAt;
  @override
  int get count;
  @override
  String? get note;
  @override
  bool get synced;

  /// Create a copy of HabitLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitLogImplCopyWith<_$HabitLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
