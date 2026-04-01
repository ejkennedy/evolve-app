import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/config/app_config.dart';
import '../../../core/di/providers.dart';
import '../../../core/network/api_endpoints.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../goals/data/models/goal.dart';
import '../../habits/data/models/habit.dart';
import 'models/chat_message.dart';

class CoachRepository {
  final Dio _dio;
  final HiveJsonBox<ChatMessage> _box;
  final String _userId;

  CoachRepository(this._dio, this._box, this._userId);

  List<ChatMessage> getHistory() => _box
      .values()
      .where((m) => m.sessionId == _userId)
      .toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  Future<void> saveMessage(ChatMessage message) async {
    await _box.put(
      message.id,
      message.copyWith(sessionId: _userId).toJson(),
    );
  }

  /// Streams a response from OpenAI given the conversation history.
  Stream<String> streamResponse({
    required List<ChatMessage> messages,
    required String systemPrompt,
  }) async* {
    // OpenAI: system prompt is the first message with role "system"
    final apiMessages = [
      {'role': 'system', 'content': systemPrompt},
      ...messages
          .where((m) => m.role != ChatRole.system)
          .map((m) => {
                'role': m.role == ChatRole.user ? 'user' : 'assistant',
                'content': m.content,
              }),
    ];

    final response = await _dio.post(
      '/chat/completions',
      options: Options(responseType: ResponseType.stream),
      data: {
        'model': AppConfig.openAiModel,
        'max_tokens': AppConfig.coachMaxTokens,
        'stream': true,
        'messages': apiMessages,
      },
    );

    final stream = response.data.stream as Stream<List<int>>;
    final buffer = StringBuffer();

    await for (final chunk in stream) {
      buffer.write(utf8.decode(chunk));
      final lines = buffer.toString().split('\n');
      buffer.clear();

      for (var i = 0; i < lines.length - 1; i++) {
        final line = lines[i].trim();
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') return;
          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            // OpenAI: choices[0].delta.content
            final choices = json['choices'] as List<dynamic>?;
            if (choices != null && choices.isNotEmpty) {
              final delta =
                  choices[0]['delta'] as Map<String, dynamic>?;
              final content = delta?['content'] as String?;
              if (content != null && content.isNotEmpty) {
                yield content;
              }
            }
          } catch (_) {
            // malformed SSE line — skip
          }
        }
      }

      if (lines.isNotEmpty) buffer.write(lines.last);
    }
  }

  String buildSystemPrompt({
    required String userName,
    required List<Goal> goals,
    required List<Habit> habits,
    Map<String, dynamic>? onboardingData,
  }) {
    final goalSummary = goals.isEmpty
        ? 'No active goals yet.'
        : goals
            .map((g) =>
                '- ${g.title} (${g.currentValue}/${g.targetValue} ${g.unit}, due ${g.targetDate.day}/${g.targetDate.month}/${g.targetDate.year})')
            .join('\n');

    final habitSummary = habits.isEmpty
        ? 'No habits tracked yet.'
        : habits.map((h) => '- ${h.title} (${h.frequency.name})').join('\n');

    final motivationStyle =
        onboardingData?['motivation_style'] as String? ?? 'balanced';

    return '''You are Evolve, a personal AI coach for $userName. You are empathic, direct, and action-oriented.

CURRENT GOALS:
$goalSummary

CURRENT HABITS:
$habitSummary

MOTIVATION STYLE: $motivationStyle

COACHING PRINCIPLES:
- Keep responses concise (2-4 sentences max unless asked for more)
- Always end with one concrete, actionable suggestion
- Acknowledge feelings before offering solutions
- Celebrate wins, no matter how small
- If the user is struggling, reframe obstacles as data, not failure

Never break character. Never mention you are an AI language model.''';
  }
}

final coachRepositoryProvider = Provider<CoachRepository>((ref) {
  final dio = ref.watch(anthropicDioProvider);
  final box = ref.watch(chatMessagesBoxProvider);
  final user = ref.watch(currentUserProvider);
  return CoachRepository(dio, box, user?.id ?? '');
});

class CoachNotifier extends StateNotifier<List<ChatMessage>> {
  final CoachRepository _repo;
  StreamSubscription<String>? _streamSub;

  CoachNotifier(this._repo) : super([]) {
    _load();
  }

  void _load() {
    state = _repo.getHistory();
  }

  Future<void> sendMessage(
    String text, {
    required String systemPrompt,
  }) async {
    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      role: ChatRole.user,
      content: text,
      createdAt: DateTime.now(),
    );
    await _repo.saveMessage(userMsg);

    final assistantId = const Uuid().v4();
    final assistantMsg = ChatMessage(
      id: assistantId,
      role: ChatRole.assistant,
      content: '',
      createdAt: DateTime.now(),
      isStreaming: true,
    );

    state = [...state, userMsg, assistantMsg];

    var accumulated = '';

    _streamSub = _repo
        .streamResponse(messages: state, systemPrompt: systemPrompt)
        .listen(
      (token) {
        accumulated += token;
        state = [
          for (final m in state)
            if (m.id == assistantId) m.copyWith(content: accumulated) else m,
        ];
      },
      onDone: () async {
        final finalMsg = assistantMsg.copyWith(
          content: accumulated,
          isStreaming: false,
        );
        await _repo.saveMessage(finalMsg);
        state = [
          for (final m in state)
            if (m.id == assistantId) finalMsg else m,
        ];
      },
      onError: (_) {
        state = [
          for (final m in state)
            if (m.id == assistantId)
              m.copyWith(
                content: 'Sorry, something went wrong. Please try again.',
                isStreaming: false,
              )
            else
              m,
        ];
      },
    );
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }
}

final coachProvider =
    StateNotifierProvider<CoachNotifier, List<ChatMessage>>((ref) {
  return CoachNotifier(ref.watch(coachRepositoryProvider));
});
