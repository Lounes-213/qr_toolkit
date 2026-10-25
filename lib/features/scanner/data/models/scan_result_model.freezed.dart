// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScanResultModel _$ScanResultModelFromJson(Map<String, dynamic> json) {
  return _ScanResultModel.fromJson(json);
}

/// @nodoc
mixin _$ScanResultModel {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get scannedAtMillis => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;

  /// Serializes this ScanResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanResultModelCopyWith<ScanResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanResultModelCopyWith<$Res> {
  factory $ScanResultModelCopyWith(
    ScanResultModel value,
    $Res Function(ScanResultModel) then,
  ) = _$ScanResultModelCopyWithImpl<$Res, ScanResultModel>;
  @useResult
  $Res call({
    String id,
    String content,
    String type,
    int scannedAtMillis,
    String? title,
  });
}

/// @nodoc
class _$ScanResultModelCopyWithImpl<$Res, $Val extends ScanResultModel>
    implements $ScanResultModelCopyWith<$Res> {
  _$ScanResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? type = null,
    Object? scannedAtMillis = null,
    Object? title = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            scannedAtMillis: null == scannedAtMillis
                ? _value.scannedAtMillis
                : scannedAtMillis // ignore: cast_nullable_to_non_nullable
                      as int,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScanResultModelImplCopyWith<$Res>
    implements $ScanResultModelCopyWith<$Res> {
  factory _$$ScanResultModelImplCopyWith(
    _$ScanResultModelImpl value,
    $Res Function(_$ScanResultModelImpl) then,
  ) = __$$ScanResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String content,
    String type,
    int scannedAtMillis,
    String? title,
  });
}

/// @nodoc
class __$$ScanResultModelImplCopyWithImpl<$Res>
    extends _$ScanResultModelCopyWithImpl<$Res, _$ScanResultModelImpl>
    implements _$$ScanResultModelImplCopyWith<$Res> {
  __$$ScanResultModelImplCopyWithImpl(
    _$ScanResultModelImpl _value,
    $Res Function(_$ScanResultModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? type = null,
    Object? scannedAtMillis = null,
    Object? title = freezed,
  }) {
    return _then(
      _$ScanResultModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        scannedAtMillis: null == scannedAtMillis
            ? _value.scannedAtMillis
            : scannedAtMillis // ignore: cast_nullable_to_non_nullable
                  as int,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanResultModelImpl extends _ScanResultModel {
  const _$ScanResultModelImpl({
    required this.id,
    required this.content,
    required this.type,
    required this.scannedAtMillis,
    this.title,
  }) : super._();

  factory _$ScanResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanResultModelImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final String type;
  @override
  final int scannedAtMillis;
  @override
  final String? title;

  @override
  String toString() {
    return 'ScanResultModel(id: $id, content: $content, type: $type, scannedAtMillis: $scannedAtMillis, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanResultModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.scannedAtMillis, scannedAtMillis) ||
                other.scannedAtMillis == scannedAtMillis) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, type, scannedAtMillis, title);

  /// Create a copy of ScanResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanResultModelImplCopyWith<_$ScanResultModelImpl> get copyWith =>
      __$$ScanResultModelImplCopyWithImpl<_$ScanResultModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanResultModelImplToJson(this);
  }
}

abstract class _ScanResultModel extends ScanResultModel {
  const factory _ScanResultModel({
    required final String id,
    required final String content,
    required final String type,
    required final int scannedAtMillis,
    final String? title,
  }) = _$ScanResultModelImpl;
  const _ScanResultModel._() : super._();

  factory _ScanResultModel.fromJson(Map<String, dynamic> json) =
      _$ScanResultModelImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  String get type;
  @override
  int get scannedAtMillis;
  @override
  String? get title;

  /// Create a copy of ScanResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanResultModelImplCopyWith<_$ScanResultModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
