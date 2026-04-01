class AppConstants {
  AppConstants._();

  // Hive box names
  static const String goalsBox = 'goals';
  static const String habitsBox = 'habits';
  static const String habitLogsBox = 'habit_logs';
  static const String chatMessagesBox = 'chat_messages';
  static const String userBox = 'user';
  static const String settingsBox = 'settings';

  // Chat
  static const int maxChatHistory = 50;
  static const int onboardingQuestionCount = 6;

  // Coach context window (last N days of logs sent to LLM)
  static const int coachContextDays = 7;

  // Insight thresholds
  static const int offTrackMissedDays = 3;
  static const double lowProbabilityThreshold = 0.4;

  // API
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration streamTimeout = Duration(minutes: 2);
}
