import 'package:qr_toolkit/core/errors/exceptions.dart';
import 'package:qr_toolkit/core/network/api_client.dart';
import 'package:qr_toolkit/features/ai_generator/domain/services/gemini_service.dart';

class GeminiServiceImpl implements GeminiService {
  const GeminiServiceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<String> generateText(String prompt) async {
    if (geminiApiKey.isEmpty || geminiApiKey == 'YOUR_GEMINI_API_KEY') {
      throw Exception('Gemini API key not configured');
    }

    final path =
        '/v1beta/models/$geminiModel:generateContent?key=$geminiApiKey';

    try {
      final response = await apiClient.post(
        path,
        body: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        },
      );

      return _parseResponse(response);
    } on ServerException {
      throw Exception('Gemini request failed');
    } on Exception {
      rethrow;
    }
  }

  String _parseResponse(Map<String, dynamic> response) {
    try {
      final candidates = response['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('No candidates returned from Gemini');
      }
      final content = candidates[0]['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List<dynamic>;
      final text = parts[0]['text'] as String;
      return text;
    } catch (_) {
      throw Exception('Failed to parse Gemini response');
    }
  }
}
