// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScanResultModelImpl _$$ScanResultModelImplFromJson(
  Map<String, dynamic> json,
) => _$ScanResultModelImpl(
  id: json['id'] as String,
  content: json['content'] as String,
  type: json['type'] as String,
  scannedAtMillis: (json['scannedAtMillis'] as num).toInt(),
  title: json['title'] as String?,
);

Map<String, dynamic> _$$ScanResultModelImplToJson(
  _$ScanResultModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'content': instance.content,
  'type': instance.type,
  'scannedAtMillis': instance.scannedAtMillis,
  'title': instance.title,
};
