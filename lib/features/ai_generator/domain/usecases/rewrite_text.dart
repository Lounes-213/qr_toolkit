import 'package:qr_toolkit/features/ai_generator/domain/services/gemini_service.dart';

class RewriteText {
  const RewriteText(this.service);

  final GeminiService service;

  Future<String> call(String text) async {
    final prompt = '''
Rewrite the following text to be clearer, more concise, and engaging.
Preserve the meaning. Return only the rewritten text.

Text:
"""
$text
"""
''';
    return service.generateText(prompt);
  }
}
