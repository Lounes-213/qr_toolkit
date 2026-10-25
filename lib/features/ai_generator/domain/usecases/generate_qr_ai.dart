import 'package:qr_toolkit/shared/enums/qr_content_type.dart';
import 'package:qr_toolkit/shared/models/qr_model.dart';

class GenerateQrAi {
  const GenerateQrAi();

  QrModel call(String prompt) {
    return QrModel(
      content: _resolveContent(prompt),
      type: QrContentType.text,
    );
  }

  String _resolveContent(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('wifi')) return 'WIFI:T:WPA;S:MyNetwork;P:password;;';
    if (lower.contains('portfolio') || lower.contains('link')) {
      return 'https://qr-toolkit.app';
    }
    return prompt;
  }
}
