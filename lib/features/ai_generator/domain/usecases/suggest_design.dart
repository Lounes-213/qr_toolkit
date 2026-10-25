import 'package:qr_toolkit/features/ai_generator/domain/services/gemini_service.dart';

class SuggestDesign {
  const SuggestDesign(this.service);

  final GeminiService service;

  Future<String> call(String content) async {
    final prompt = '''
Based on the following QR code description, suggest concrete design
improvements: colors, gradient, eye style, dot style, and logo placement.
Keep it practical.

Description:
"""
$content
"""
''';
    return service.generateText(prompt);
  }
}
