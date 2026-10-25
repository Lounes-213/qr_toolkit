import 'package:qr_toolkit/features/ai_generator/domain/services/gemini_service.dart';

class ExplainQr {
  const ExplainQr(this.service);

  final GeminiService service;

  Future<String> call(String content) async {
    final prompt = '''
You are a QR code assistant. Given the following raw QR code content,
explain in a friendly way what it contains, what type of data it is
(URL, text, WiFi, contact, etc.), and any useful context.

QR content:
"""
$content
"""
''';
    return service.generateText(prompt);
  }
}
