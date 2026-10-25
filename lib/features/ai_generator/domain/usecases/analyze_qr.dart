import 'package:qr_toolkit/features/ai_generator/domain/services/gemini_service.dart';

class AnalyzeQr {
  const AnalyzeQr(this.service);

  final GeminiService service;

  Future<String> call(String content) async {
    final prompt = '''
Analyze the following QR code content. Categorize it and summarize its
purpose, safety considerations, and suggested QR content type.

QR content:
"""
$content
"""
''';
    return service.generateText(prompt);
  }
}
