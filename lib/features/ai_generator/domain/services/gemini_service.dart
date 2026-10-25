abstract class GeminiService {
  Future<String> generateText(String prompt);
}

const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
const String geminiModel = 'gemini-3.5-flash';
