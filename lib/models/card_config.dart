import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../core/app_fonts.dart';

/// Type of canvas background
enum CanvasType { color, template, gallery, camera }

/// Model for the photo card configuration
class CardConfig {
  final CanvasType canvasType;
  final Color? backgroundColor;
  final String? templatePath;
  final Uint8List? imageBytes;
  final String text;
  final AppFont font;
  final Color textColor;
  final double fontSize;

  const CardConfig({
    this.canvasType = CanvasType.color,
    this.backgroundColor,
    this.templatePath,
    this.imageBytes,
    this.text = '',
    this.font = AppFont.hadi,
    this.textColor = Colors.white,
    this.fontSize = 48,
  });

  CardConfig copyWith({
    CanvasType? canvasType,
    Color? backgroundColor,
    String? templatePath,
    Uint8List? imageBytes,
    String? text,
    AppFont? font,
    Color? textColor,
    double? fontSize,
  }) {
    return CardConfig(
      canvasType: canvasType ?? this.canvasType,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      templatePath: templatePath ?? this.templatePath,
      imageBytes: imageBytes ?? this.imageBytes,
      text: text ?? this.text,
      font: font ?? this.font,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}
