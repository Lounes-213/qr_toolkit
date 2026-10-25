// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScanResultImpl _$$ScanResultImplFromJson(Map<String, dynamic> json) =>
    _$ScanResultImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$QrContentTypeEnumMap, json['type']),
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$$ScanResultImplToJson(_$ScanResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': _$QrContentTypeEnumMap[instance.type]!,
      'scannedAt': instance.scannedAt.toIso8601String(),
      'title': instance.title,
    };

const _$QrContentTypeEnumMap = {
  QrContentType.url: 'url',
  QrContentType.text: 'text',
  QrContentType.email: 'email',
  QrContentType.phone: 'phone',
  QrContentType.sms: 'sms',
  QrContentType.wifi: 'wifi',
  QrContentType.contact: 'contact',
  QrContentType.geo: 'geo',
  QrContentType.event: 'event',
  QrContentType.other: 'other',
};
