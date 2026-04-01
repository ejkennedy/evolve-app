class ApiEndpoints {
  ApiEndpoints._();

  // Anthropic
  static const String messages = '/messages';

  // Backend (Phase 2 – FastAPI)
  static const String coachChat = '/api/v1/coach/chat';
  static const String insights = '/api/v1/insights';
  static const String weeklyReview = '/api/v1/insights/weekly-review';
  static const String syncGoals = '/api/v1/goals/sync';
  static const String syncHabits = '/api/v1/habits/sync';
  static const String syncLogs = '/api/v1/logs/sync';
}
