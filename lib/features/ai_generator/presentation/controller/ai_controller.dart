import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:qr_toolkit/core/network/api_client.dart';
import 'package:qr_toolkit/features/ai_generator/domain/services/gemini_service.dart';
import 'package:qr_toolkit/features/ai_generator/domain/services/gemini_service_impl.dart';
import 'package:qr_toolkit/features/ai_generator/domain/usecases/analyze_qr.dart';
import 'package:qr_toolkit/features/ai_generator/domain/usecases/explain_qr.dart';
import 'package:qr_toolkit/features/ai_generator/domain/usecases/generate_wifi_qr.dart';
import 'package:qr_toolkit/features/ai_generator/domain/usecases/rewrite_text.dart';
import 'package:qr_toolkit/features/ai_generator/domain/usecases/suggest_design.dart';

class AiState {
  const AiState({
    this.lastResponse,
    this.loading = false,
    this.error,
    this.messages = const [],
  });

  final String? lastResponse;
  final bool loading;
  final String? error;
  final List<String> messages;

  AiState copyWith({
    String? lastResponse,
    bool? loading,
    String? error,
    List<String>? messages,
  }) {
    return AiState(
      lastResponse: lastResponse ?? this.lastResponse,
      loading: loading ?? this.loading,
      error: error,
      messages: messages ?? this.messages,
    );
  }
}

final aiControllerProvider =
    StateNotifierProvider<AiController, AiState>((ref) {
  final gemini = GeminiServiceImpl(
    apiClient: HttpApiClient(
      baseUrl: 'https://generativelanguage.googleapis.com',
      client: http.Client(),
    ),
  );
  return AiController(gemini);
});

class AiController extends StateNotifier<AiState> {
  AiController(this._gemini) : super(const AiState());

  final GeminiService _gemini;

  late final ExplainQr _explainQr = ExplainQr(_gemini);
  late final AnalyzeQr _analyzeQr = AnalyzeQr(_gemini);
  late final SuggestDesign _suggestDesign = SuggestDesign(_gemini);
  late final GenerateWifiQr _generateWifiQr = GenerateWifiQr(_gemini);
  late final RewriteText _rewriteText = RewriteText(_gemini);

  Future<void> sendPrompt(String prompt) async {
    final text = prompt.trim();
    if (text.isEmpty) return;
    state = state.copyWith(
      loading: true,
      error: null,
      messages: [...state.messages, 'USER::$text'],
    );
    try {
      final response = await _gemini.generateText(text);
      state = state.copyWith(
        loading: false,
        lastResponse: response,
        messages: [...state.messages, 'AI::$response'],
      );
    } on Exception catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
        messages: [
          ...state.messages,
          'AI::Sorry, I hit an error: ${e.toString().replaceFirst('Exception: ', '')}'
        ],
      );
    }
  }

  Future<void> explainQr(String content) =>
      _run('Explain this QR:\n$content', _explainQr.call(content));

  Future<void> analyzeQr(String content) =>
      _run('Analyze this QR:\n$content', _analyzeQr.call(content));

  Future<void> suggestDesign(String content) =>
      _run('Suggest a design for:\n$content', _suggestDesign.call(content));

  Future<void> generateWifiQr(String desc) =>
      _run('Generate WiFi QR for:\n$desc', _generateWifiQr.call(desc));

  Future<void> rewriteText(String text) =>
      _run('Rewrite:\n$text', _rewriteText.call(text));

  Future<void> _run(String display, Future<String> future) async {
    state = state.copyWith(
      loading: true,
      error: null,
      messages: [...state.messages, 'USER::$display'],
    );
    try {
      final response = await future;
      state = state.copyWith(
        loading: false,
        lastResponse: response,
        messages: [...state.messages, 'AI::$response'],
      );
    } on Exception catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(
        loading: false,
        error: message,
        messages: [
          ...state.messages,
          'AI::Sorry, I hit an error: $message'
        ],
      );
    }
  }
}
