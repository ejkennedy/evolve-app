/// App-wide configuration constants.
/// Sensitive values (API keys, Supabase URL) are loaded via envied
/// at compile time and never bundled as plaintext files.
class AppConfig {
  AppConfig._();

  static const String appName = 'Evolve';
  static const String appVersion = '0.1.0';

  // These are injected at build time via envied — see lib/core/config/env.dart
  // Run: flutter pub run build_runner build to regenerate env.g.dart
  static const String anthropicBaseUrl = 'https://api.anthropic.com/v1';
  static const String anthropicModel = 'claude-sonnet-4-6';

  // Max tokens for coach responses
  static const int coachMaxTokens = 1024;
}
