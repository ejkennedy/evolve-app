import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/data/models/app_user.dart';
import '../../../../core/di/providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

const _onboardingScript = [
  "Hi! I'm your Evolve coach 👋 I'll ask you a few quick questions so I can personalise your experience. What's your name?",
  "Great to meet you! What's one big goal you'd like to achieve in the next 3 months? Be as specific as you like.",
  "Love it! Now, what's one daily habit you already have that you're proud of? It can be anything — even making your bed counts!",
  "Nice! What time of day do you tend to have the most energy and motivation?",
  "How do you prefer to be motivated? (e.g. gentle reminders, direct challenges, data and stats, or a mix?)",
  "Last question: what's the biggest obstacle that has stopped you from reaching your goals in the past?",
];

class OnboardingChatScreen extends ConsumerStatefulWidget {
  const OnboardingChatScreen({super.key});

  @override
  ConsumerState<OnboardingChatScreen> createState() =>
      _OnboardingChatScreenState();
}

class _OnboardingChatScreenState extends ConsumerState<OnboardingChatScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_Msg> _messages = [];
  int _questionIndex = 0;
  bool _isComplete = false;
  bool _saving = false;
  final Map<String, dynamic> _answers = {};

  static const _answerKeys = [
    'name',
    'main_goal',
    'existing_habit',
    'peak_energy_time',
    'motivation_style',
    'main_obstacle',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addCoachMessage(_onboardingScript[0]);
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _addCoachMessage(String text) {
    setState(() => _messages.add(_Msg(text: text, isUser: false)));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendAnswer() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    _inputCtrl.clear();

    setState(() => _messages.add(_Msg(text: text, isUser: true)));
    _scrollToBottom();

    _answers[_answerKeys[_questionIndex]] = text;
    _questionIndex++;

    if (_questionIndex < _onboardingScript.length) {
      await Future.delayed(const Duration(milliseconds: 600));
      _addCoachMessage(_onboardingScript[_questionIndex]);
    } else {
      await Future.delayed(const Duration(milliseconds: 600));
      _addCoachMessage(
        "Amazing, ${_answers['name']}! I've got everything I need. Let's build your personalised plan! 🚀",
      );
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() => _isComplete = true);
    }
  }

  Future<void> _finishOnboarding() async {
    setState(() => _saving = true);
    final supaUser = ref.read(supabaseClientProvider).auth.currentUser;
    if (supaUser == null) return;

    final user = AppUser(
      id: supaUser.id,
      email: supaUser.email ?? '',
      displayName: _answers['name'] as String?,
      onboardingComplete: true,
      onboardingData: Map<String, dynamic>.from(_answers),
      createdAt: DateTime.now(),
    );

    await ref.read(authNotifierProvider.notifier).saveUser(user);
    if (mounted) context.go(RouteConstants.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Meet your coach'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _questionIndex / _onboardingScript.length,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _Bubble(msg: _messages[i]),
            ),
          ),
          if (_isComplete)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.sm,
                AppSpacing.pagePadding,
                AppSpacing.sm + MediaQuery.paddingOf(context).bottom,
              ),
              child: FilledButton.icon(
                onPressed: _saving ? null : _finishOnboarding,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.rocket_launch),
                label: const Text("Let's go!"),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            )
          else
            _InputBar(controller: _inputCtrl, onSend: _sendAnswer),
        ],
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool isUser;
  _Msg({required this.text, required this.isUser});
}

class _Bubble extends StatelessWidget {
  final _Msg msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm + 4,
              ),
              decoration: BoxDecoration(
                color: msg.isUser
                    ? AppColors.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppSpacing.radiusMd),
                  topRight: const Radius.circular(AppSpacing.radiusMd),
                  bottomLeft:
                      Radius.circular(msg.isUser ? AppSpacing.radiusMd : 4),
                  bottomRight:
                      Radius.circular(msg.isUser ? 4 : AppSpacing.radiusMd),
                ),
              ),
              child: Text(
                msg.text,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: msg.isUser
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          if (msg.isUser) const SizedBox(width: AppSpacing.sm + 28),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.onSurfaceMuted.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Type your answer…',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              ),
            ),
          ),
          FilledButton(
            onPressed: onSend,
            child: const Icon(Icons.send, size: 18),
          ),
        ],
      ),
    );
  }
}
