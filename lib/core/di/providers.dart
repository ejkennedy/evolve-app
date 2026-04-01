import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../network/dio_client.dart';
import '../../features/auth/data/models/app_user.dart';
import '../../features/goals/data/models/goal.dart';
import '../../features/habits/data/models/habit.dart';
import '../../features/habits/data/models/habit_log.dart';
import '../../features/coach/data/models/chat_message.dart';

// Infrastructure
final anthropicDioProvider = Provider<Dio>((ref) => createAnthropicDio());

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

// Typed Hive box accessors using JSON serialisation

class HiveJsonBox<T> {
  final Box<String> _box;
  final T Function(Map<String, dynamic>) _fromJson;

  HiveJsonBox(this._box, this._fromJson);

  T? get(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    return _fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  List<T> values() => _box.values
      .map((raw) => _fromJson(jsonDecode(raw) as Map<String, dynamic>))
      .toList();

  Future<void> put(String key, Map<String, dynamic> json) async {
    await _box.put(key, jsonEncode(json));
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  bool containsKey(String key) => _box.containsKey(key);
}

final goalsBoxProvider = Provider<HiveJsonBox<Goal>>(
  (ref) => HiveJsonBox(Hive.box<String>('goals'), Goal.fromJson),
);

final habitsBoxProvider = Provider<HiveJsonBox<Habit>>(
  (ref) => HiveJsonBox(Hive.box<String>('habits'), Habit.fromJson),
);

final habitLogsBoxProvider = Provider<HiveJsonBox<HabitLog>>(
  (ref) => HiveJsonBox(Hive.box<String>('habit_logs'), HabitLog.fromJson),
);

final chatMessagesBoxProvider = Provider<HiveJsonBox<ChatMessage>>(
  (ref) =>
      HiveJsonBox(Hive.box<String>('chat_messages'), ChatMessage.fromJson),
);

final userBoxProvider = Provider<HiveJsonBox<AppUser>>(
  (ref) => HiveJsonBox(Hive.box<String>('user'), AppUser.fromJson),
);

final settingsBoxProvider = Provider<Box<dynamic>>(
  (ref) => Hive.box<dynamic>('settings'),
);
