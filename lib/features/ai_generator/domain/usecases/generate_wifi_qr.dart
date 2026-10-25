import 'package:qr_toolkit/features/ai_generator/domain/services/gemini_service.dart';

class GenerateWifiQr {
  const GenerateWifiQr(this.service);

  final GeminiService service;

  Future<String> call(String description) async {
    final prompt = '''
Generate a valid WIFI QR payload from this description.
Return ONLY the WIFI payload in the exact format:
WIFI:T:<auth>;S:<ssid>;P:<password>;H:<hidden>;;
(auth is WPA or WEP or nopass; H is true/false).

Description:
"""
$description
"""
''';
    return service.generateText(prompt);
  }
}
