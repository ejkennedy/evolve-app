/// App-wide configuration constants.
/// Sensitive values (API keys, Supabase URL) are loaded via envied
/// at compile time and never bundled as plaintext files.
class AppConfig {
  AppConfig._();

  static const String appName = 'Evolve';
  static const String appVersion = '0.1.0';

  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  static const String openAiModel = 'gpt-4o';

  // Max tokens for coach responses
  static const int coachMaxTokens = 1024;
}
