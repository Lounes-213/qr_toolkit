import 'package:equatable/equatable.dart';
import 'package:qr_toolkit/shared/enums/qr_content_type.dart';

class QrModel extends Equatable {
  const QrModel({
    required this.content,
    required this.type,
    this.color = 0xFF000000,
    this.backgroundColor = 0xFFFFFFFF,
    this.logoPath,
    this.gradientStart,
    this.gradientEnd,
    this.eyeStyle = 'square',
    this.dotStyle = 'square',
  });

  final String content;
  final QrContentType type;
  final int color;
  final int backgroundColor;
  final String? logoPath;
  final int? gradientStart;
  final int? gradientEnd;
  final String eyeStyle;
  final String dotStyle;

  QrModel copyWith({
    String? content,
    QrContentType? type,
    int? color,
    int? backgroundColor,
    String? logoPath,
    int? gradientStart,
    int? gradientEnd,
    String? eyeStyle,
    String? dotStyle,
  }) {
    return QrModel(
      content: content ?? this.content,
      type: type ?? this.type,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      logoPath: logoPath ?? this.logoPath,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      eyeStyle: eyeStyle ?? this.eyeStyle,
      dotStyle: dotStyle ?? this.dotStyle,
    );
  }

  @override
  List<Object?> get props => [
        content,
        type,
        color,
        backgroundColor,
        logoPath,
        gradientStart,
        gradientEnd,
        eyeStyle,
        dotStyle,
      ];
}
