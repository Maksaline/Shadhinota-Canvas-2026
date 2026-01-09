import 'dart:convert' as ui;
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../core/app_fonts.dart';
import '../models/card_config.dart';

class CardProvider extends ChangeNotifier {
  CardConfig _config = CardConfig(
    backgroundColor: AppColors.bloodRed,
  );
  double aspectRatio = 1.0;

  CardConfig get config => _config;

  // Canvas setters
  void setColorCanvas(Color color) {
    _config = _config.copyWith(
      canvasType: CanvasType.color,
      backgroundColor: color,
      templatePath: null,
      imageBytes: null,
    );
    notifyListeners();
  }

  Future<void> setTemplateCanvas(String templatePath) async {
    try {
      final ByteData data = await rootBundle.load(templatePath);
      final Uint8List bytes = data.buffer.asUint8List();
      setAspectRatioBytes(bytes);
    } catch (e) {
      debugPrint('Error calculating aspect ratio: $e');
    }
    _config = _config.copyWith(
      canvasType: CanvasType.template,
      templatePath: templatePath,
      backgroundColor: null,
      imageBytes: null,
    );
    notifyListeners();
  }

  void setImageCanvas(Uint8List imageBytes, CanvasType type) {
    setAspectRatioBytes(imageBytes);

    _config = _config.copyWith(
      canvasType: type,
      imageBytes: imageBytes,
      backgroundColor: null,
      templatePath: null,
    );
    notifyListeners();
  }

  // Text setters
  void setText(String text) {
    _config = _config.copyWith(text: text);
    notifyListeners();
  }

  void setFont(AppFont font) {
    _config = _config.copyWith(font: font);
    notifyListeners();
  }

  void setTextColor(Color color) {
    _config = _config.copyWith(textColor: color);
    notifyListeners();
  }

  void setFontSize(double size) {
    _config = _config.copyWith(fontSize: size);
    notifyListeners();
  }

  void setAspectRatioBytes(Uint8List bytes) async {
    final image = await decodeImageFromList(bytes);
    aspectRatio = image.width / image.height;
    notifyListeners();
    image.dispose();
  }

  // Reset
  void reset() {
    _config = CardConfig(
      backgroundColor: AppColors.bloodRed,
    );
    notifyListeners();
  }
}
