import 'package:flutter/material.dart';

enum QrContentType {
  url,
  text,
  email,
  phone,
  sms,
  wifi,
  contact,
  geo,
  event,
  other,
  whatsapp,
  telegram,
  instagram,
  facebook,
  tiktok,
  youtube,
  linkedin,
  pdf,
  image,
  video,
  audio,
  custom;

  String get label {
    switch (this) {
      case QrContentType.url:
        return 'URL';
      case QrContentType.text:
        return 'Text';
      case QrContentType.email:
        return 'Email';
      case QrContentType.phone:
        return 'Phone';
      case QrContentType.sms:
        return 'SMS';
      case QrContentType.wifi:
        return 'WiFi';
      case QrContentType.contact:
        return 'Contact';
      case QrContentType.geo:
        return 'Location';
      case QrContentType.event:
        return 'Event';
      case QrContentType.other:
        return 'Other';
      case QrContentType.whatsapp:
        return 'WhatsApp';
      case QrContentType.telegram:
        return 'Telegram';
      case QrContentType.instagram:
        return 'Instagram';
      case QrContentType.facebook:
        return 'Facebook';
      case QrContentType.tiktok:
        return 'TikTok';
      case QrContentType.youtube:
        return 'YouTube';
      case QrContentType.linkedin:
        return 'LinkedIn';
      case QrContentType.pdf:
        return 'PDF';
      case QrContentType.image:
        return 'Image';
      case QrContentType.video:
        return 'Video';
      case QrContentType.audio:
        return 'Audio';
      case QrContentType.custom:
        return 'Custom';
    }
  }

  IconData get icon {
    switch (this) {
      case QrContentType.url:
        return Icons.link;
      case QrContentType.text:
        return Icons.text_fields;
      case QrContentType.email:
        return Icons.email;
      case QrContentType.phone:
        return Icons.phone;
      case QrContentType.sms:
        return Icons.sms;
      case QrContentType.wifi:
        return Icons.wifi;
      case QrContentType.contact:
        return Icons.contacts;
      case QrContentType.geo:
        return Icons.location_on;
      case QrContentType.event:
        return Icons.event;
      case QrContentType.other:
        return Icons.qr_code;
      case QrContentType.whatsapp:
        return Icons.chat;
      case QrContentType.telegram:
        return Icons.send;
      case QrContentType.instagram:
        return Icons.camera_alt;
      case QrContentType.facebook:
        return Icons.facebook;
      case QrContentType.tiktok:
        return Icons.music_note;
      case QrContentType.youtube:
        return Icons.play_circle_filled;
      case QrContentType.linkedin:
        return Icons.work;
      case QrContentType.pdf:
        return Icons.picture_as_pdf;
      case QrContentType.image:
        return Icons.image;
      case QrContentType.video:
        return Icons.videocam;
      case QrContentType.audio:
        return Icons.audiotrack;
      case QrContentType.custom:
        return Icons.code;
    }
  }
}
