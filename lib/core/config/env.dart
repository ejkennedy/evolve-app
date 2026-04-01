import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Compile-time / runtime environment variables loaded from a `.env` file.
/// The `.env` file is listed in pubspec.yaml assets and bundled with the app.
/// Never commit `.env` — use `.env.example` as the template.
class Env {
  Env._();

  static String get anthropicApiKey =>
      dotenv.env['ANTHROPIC_API_KEY'] ?? '';

  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? '';

  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}
