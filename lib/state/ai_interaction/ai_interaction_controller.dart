import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../services/analytics/analytics_service.dart';
import '../../types/domain_models.dart';

class AIInteractionController extends ChangeNotifier {
  AIInteractionController({required this.analytics});

  final AnalyticsService analytics;

  AIMode selectedMode = AIMode.quietHelper;
  AIStatusValue status = AIStatusValue.listening;
  String promptDraft = '';
  String? latestResponse;
  bool memoryEnabled = false;
  int _requestGeneration = 0;

  bool get isOff => status == AIStatusValue.off || selectedMode == AIMode.off;

  bool get isBusy =>
      status == AIStatusValue.thinking || status == AIStatusValue.speaking;

  void syncWithRoomMode(AIMode mode) {
    if (mode == AIMode.off) {
      if (selectedMode != AIMode.off || status != AIStatusValue.off) {
        selectedMode = AIMode.off;
        status = AIStatusValue.off;
        notifyListeners();
      }
      return;
    }

    if (selectedMode == mode && status != AIStatusValue.off) return;
    selectedMode = mode;
    status = AIStatusValue.listening;
    notifyListeners();
  }

  void setPromptDraft(String value) {
    promptDraft = value;
    notifyListeners();
  }

  void selectMode(AIMode mode) {
    if (mode == AIMode.off) {
      turnOffAI();
      return;
    }

    selectedMode = mode;
    if (status == AIStatusValue.off) {
      status = AIStatusValue.listening;
    }
    unawaited(analytics.track('ai_mode_changed', {'ai_mode': mode.name}));
    notifyListeners();
  }

  Future<void> askPrompt() async {
    final prompt = promptDraft.trim();
    if (prompt.isEmpty || isOff || isBusy) return;
    promptDraft = '';
    unawaited(
      analytics.track('ai_asked', {
        'source': 'drawer_prompt',
        'ai_mode': selectedMode.name,
      }),
    );
    await _runMockResponse(_responseForPrompt(prompt));
  }

  Future<void> runQuickAction(String actionLabel) async {
    if (isOff || isBusy) return;
    unawaited(
      analytics.track('ai_quick_action_clicked', {
        'action': actionLabel,
        'ai_mode': selectedMode.name,
      }),
    );
    await _runMockResponse(_responseForQuickAction(actionLabel));
  }

  void viewMemoryState() {
    unawaited(
      analytics.track('ai_memory_state_viewed', {
        'memory_enabled': memoryEnabled,
      }),
    );
  }

  void turnOffAI() {
    _requestGeneration++;
    selectedMode = AIMode.off;
    status = AIStatusValue.off;
    latestResponse =
        'AI is off. It will not listen or respond until you turn it on again.';
    unawaited(analytics.track('ai_disabled', {'source': 'drawer'}));
    notifyListeners();
  }

  Future<void> _runMockResponse(String response) async {
    final generation = ++_requestGeneration;
    status = AIStatusValue.thinking;
    latestResponse = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (generation != _requestGeneration || isOff) return;
    status = AIStatusValue.speaking;
    latestResponse = response;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (generation != _requestGeneration || isOff) return;
    status = AIStatusValue.listening;
    notifyListeners();
  }

  String _responseForPrompt(String prompt) {
    return 'For "$prompt", try naming one reason for each side, then ask what evidence would change someone\'s mind.';
  }

  String _responseForQuickAction(String actionLabel) => switch (actionLabel) {
    'Summarize so far' =>
      'So far: one side values flexibility, the other values coordination. The useful next step is comparing trade-offs.',
    'Suggest a better question' =>
      'Better question: What kind of work benefits most from remote time, and what needs face-to-face trust?',
    'Explain both sides' =>
      'One side argues remote work improves focus and access. The other says office time builds trust and faster feedback.',
    'Translate' =>
      'Translation mode is mocked for now. In production, this would translate requested messages only.',
    _ => 'AI can help when you ask a specific, respectful question.',
  };
}
