import 'package:flutter/material.dart';

import 'package:qr_toolkit/shared/enums/qr_content_type.dart';

class _FieldDef {
  const _FieldDef(
    this.name,
    this.label, {
    this.hint = '',
    this.multiline = false,
    this.obscure = false,
  });

  final String name;
  final String label;
  final String hint;
  final bool multiline;
  final bool obscure;
}

class TypeFormFields extends StatefulWidget {
  const TypeFormFields({super.key, required this.type});

  final QrContentType type;

  @override
  State<TypeFormFields> createState() => TypeFormFieldsState();
}

class TypeFormFieldsState extends State<TypeFormFields> {
  final Map<String, TextEditingController> _controllers = {};

  static const Map<QrContentType, List<_FieldDef>> _fields = {
    QrContentType.url: [
      _FieldDef('url', 'URL', hint: 'https://example.com'),
    ],
    QrContentType.text: [
      _FieldDef('text', 'Text', multiline: true),
    ],
    QrContentType.email: [
      _FieldDef('email', 'Email', hint: 'me@example.com'),
      _FieldDef('subject', 'Subject', hint: 'Optional'),
      _FieldDef('body', 'Body', multiline: true, hint: 'Optional'),
    ],
    QrContentType.phone: [
      _FieldDef('number', 'Phone number'),
    ],
    QrContentType.sms: [
      _FieldDef('number', 'Phone number'),
      _FieldDef('message', 'Message', multiline: true),
    ],
    QrContentType.whatsapp: [
      _FieldDef('number', 'Phone number', hint: 'without +'),
      _FieldDef('message', 'Message', multiline: true, hint: 'Optional'),
    ],
    QrContentType.telegram: [
      _FieldDef('username', 'Username', hint: 'without @'),
    ],
    QrContentType.instagram: [
      _FieldDef('username', 'Username', hint: 'without @'),
    ],
    QrContentType.facebook: [
      _FieldDef('username', 'Username or page', hint: 'without /'),
    ],
    QrContentType.tiktok: [
      _FieldDef('username', 'Username', hint: 'without @'),
    ],
    QrContentType.youtube: [
      _FieldDef('channel', 'Channel handle', hint: '@handle or id'),
    ],
    QrContentType.linkedin: [
      _FieldDef('username', 'Profile slug', hint: 'after /in/'),
    ],
    QrContentType.wifi: [
      _FieldDef('ssid', 'Network name (SSID)'),
      _FieldDef('password', 'Password', obscure: true),
      _FieldDef('auth', 'Auth', hint: 'WPA, WEP or leave blank'),
      _FieldDef('hidden', 'Hidden (true/false)', hint: 'false'),
    ],
    QrContentType.contact: [
      _FieldDef('first', 'First name'),
      _FieldDef('last', 'Last name'),
      _FieldDef('phone', 'Phone'),
      _FieldDef('email', 'Email'),
    ],
    QrContentType.geo: [
      _FieldDef('lat', 'Latitude'),
      _FieldDef('lon', 'Longitude'),
    ],
    QrContentType.event: [
      _FieldDef('title', 'Title'),
      _FieldDef('start', 'Start', hint: 'YYYYMMDDTHHMMSS'),
      _FieldDef('end', 'End', hint: 'YYYYMMDDTHHMMSS'),
    ],
    QrContentType.pdf: [
      _FieldDef('url', 'File URL'),
    ],
    QrContentType.image: [
      _FieldDef('url', 'Image URL'),
    ],
    QrContentType.video: [
      _FieldDef('url', 'Video URL'),
    ],
    QrContentType.audio: [
      _FieldDef('url', 'Audio URL'),
    ],
    QrContentType.custom: [
      _FieldDef('raw', 'Raw content', multiline: true),
    ],
    QrContentType.other: [
      _FieldDef('content', 'Content', multiline: true),
    ],
  };

  List<_FieldDef> get _fieldDefs =>
      _fields[widget.type] ?? const [_FieldDef('content', 'Content')];

  @override
  void initState() {
    super.initState();
    for (final d in _fieldDefs) {
      _controllers[d.name] = TextEditingController();
    }
  }

  @override
  void didUpdateWidget(covariant TypeFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type) {
      _controllers
        ..forEach((_, c) => c.dispose())
        ..clear();
      for (final d in _fieldDefs) {
        _controllers[d.name] = TextEditingController();
      }
    }
  }

  Map<String, String> collect() =>
      {for (final e in _controllers.entries) e.key: e.value.text};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _fieldDefs
          .map(
            (d) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextFormField(
                controller: _controllers[d.name],
                obscureText: d.obscure,
                maxLines: d.multiline ? 3 : 1,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: d.label,
                  hintText: d.hint.isEmpty ? null : d.hint,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
