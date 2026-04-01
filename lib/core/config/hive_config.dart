import 'package:hive_flutter/hive_flutter.dart';

/// Hive configuration. We store all models as JSON strings in Box<String>
/// so we don't need hive_generator or TypeAdapters.
/// Serialisation/deserialisation is done via Freezed's fromJson/toJson.
class HiveConfig {
  HiveConfig._();

  static Future<void> init() async {
    await Hive.initFlutter();
    await _openBoxes();
  }

  static Future<void> _openBoxes() async {
    await Future.wait([
      Hive.openBox<String>('user'),
      Hive.openBox<String>('goals'),
      Hive.openBox<String>('habits'),
      Hive.openBox<String>('habit_logs'),
      Hive.openBox<String>('chat_messages'),
      Hive.openBox<dynamic>('settings'),
    ]);
  }
}
