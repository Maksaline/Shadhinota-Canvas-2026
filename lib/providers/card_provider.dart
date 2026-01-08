import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_fonts.dart';
import '../models/card_config.dart';

class CardProvider extends ChangeNotifier {
  CardConfig _config = CardConfig(
    backgroundColor: AppColors.bloodRed,
  );

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

  void setTemplateCanvas(String templatePath) {
    _config = _config.copyWith(
      canvasType: CanvasType.template,
      templatePath: templatePath,
      backgroundColor: null,
      imageBytes: null,
    );
    notifyListeners();
  }

  void setImageCanvas(Uint8List imageBytes, CanvasType type) {
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

  // Reset
  void reset() {
    _config = CardConfig(
      backgroundColor: AppColors.bloodRed,
    );
    notifyListeners();
  }
}
