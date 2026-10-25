import 'package:qr_toolkit/shared/enums/qr_content_type.dart';

class QrContentBuilder {
  const QrContentBuilder();

  String build(QrContentType type, Map<String, String> fields) {
    final f = fields;
    switch (type) {
      case QrContentType.url:
        return f['url'] ?? '';
      case QrContentType.text:
        return f['text'] ?? '';
      case QrContentType.email:
        final subject = f['subject'] ?? '';
        final body = f['body'] ?? '';
        final query = <String>[];
        if (subject.isNotEmpty) query.add('subject=${_enc(subject)}');
        if (body.isNotEmpty) query.add('body=${_enc(body)}');
        final q = query.isNotEmpty ? '?${query.join('&')}' : '';
        return 'mailto:${f['email'] ?? ''}$q';
      case QrContentType.phone:
        return 'tel:${f['number'] ?? ''}';
      case QrContentType.sms:
        return 'SMSTO:${f['number'] ?? ''}:${f['message'] ?? ''}';
      case QrContentType.whatsapp:
        final message = f['message'] ?? '';
        final q = message.isNotEmpty ? '?text=${_enc(message)}' : '';
        return 'https://wa.me/${f['number'] ?? ''}$q';
      case QrContentType.telegram:
        return 'https://t.me/${f['username'] ?? ''}';
      case QrContentType.instagram:
        return 'https://instagram.com/${f['username'] ?? ''}';
      case QrContentType.facebook:
        return 'https://facebook.com/${f['username'] ?? ''}';
      case QrContentType.tiktok:
        return 'https://tiktok.com/@${f['username'] ?? ''}';
      case QrContentType.youtube:
        return 'https://youtube.com/@${f['channel'] ?? f['id'] ?? ''}';
      case QrContentType.linkedin:
        return 'https://linkedin.com/in/${f['username'] ?? ''}';
      case QrContentType.wifi:
        final auth = f['auth'] ?? '';
        final hidden = (f['hidden'] ?? 'false').toLowerCase() == 'true';
        return 'WIFI:T:$auth;S:${f['ssid'] ?? ''};'
            'P:${f['password'] ?? ''};H:${hidden ? 'true' : 'false'};;';
      case QrContentType.contact:
        final first = f['first'] ?? '';
        final last = f['last'] ?? '';
        return 'BEGIN:VCARD\n'
            'VERSION:3.0\n'
            'N:$last;$first;;;\n'
            'FN:$first $last\n'
            'TEL:${f['phone'] ?? ''}\n'
            'EMAIL:${f['email'] ?? ''}\n'
            'END:VCARD';
      case QrContentType.geo:
        final lat = f['lat'] ?? '';
        final lon = f['lon'] ?? '';
        return 'geo:$lat,$lon?q=$lat,$lon';
      case QrContentType.event:
        return 'BEGIN:VEVENT\n'
            'SUMMARY:${f['title'] ?? ''}\n'
            'DTSTART:${f['start'] ?? ''}\n'
            'DTEND:${f['end'] ?? ''}\n'
            'END:VEVENT';
      case QrContentType.pdf:
      case QrContentType.image:
      case QrContentType.video:
      case QrContentType.audio:
        return f['url'] ?? '';
      case QrContentType.custom:
        return f['raw'] ?? '';
      case QrContentType.other:
        return f['content'] ?? '';
    }
  }

  String _enc(String value) => Uri.encodeQueryComponent(value);
}
