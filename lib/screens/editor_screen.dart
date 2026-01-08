import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/app_fonts.dart';
import '../models/card_config.dart';
import '../providers/card_provider.dart';
import '../services/image_service.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final GlobalKey _canvasKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final config = context.read<CardProvider>().config;
    _textController.text = config.text;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Card'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset'),
                  content: const Text('Are you sure you want to reset?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,)),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CardProvider>().reset();
                        setState(() {
                          _textController.clear();
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Reset', style: TextStyle(color: Colors.red)),
                    ),
                  ]
                )
              );
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
          ),
          IconButton(
            onPressed: _isSaving ? null : _saveToGallery,
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_alt),
            tooltip: 'Save to Gallery',
          ),
        ],
      ),
      body: Column(
        children: [
          // Canvas Preview
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.2 * 255).round()),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: RepaintBoundary(
                  key: _canvasKey,
                  child: _buildCanvas(),
                ),
              ),
            ),
          ),

          // Controls
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).round()),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: _buildControls(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    return Consumer<CardProvider>(
      builder: (context, provider, _) {
        final config = provider.config;

        return AspectRatio(
          aspectRatio: 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              _buildBackground(config),

              // Text Overlay
              if (config.text.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      config.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: config.font.fontFamily,
                        fontSize: config.fontSize,
                        color: config.textColor,
                        shadows: [
                          Shadow(
                            color: Colors.black.withAlpha((0.5 * 255).round()),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground(CardConfig config) {
    switch (config.canvasType) {
      case CanvasType.color:
        return Container(
          color: config.backgroundColor ?? AppColors.bloodRed,
        );
      case CanvasType.template:
        return Image.asset(
          config.templatePath!,
          fit: BoxFit.contain,
        );
      case CanvasType.gallery:
      case CanvasType.camera:
        return Image.memory(
          config.imageBytes!,
          fit: BoxFit.contain,
        );
    }
  }

  Widget _buildControls() {
    return Consumer<CardProvider>(
      builder: (context, provider, _) {
        final config = provider.config;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Input
              TextField(
                controller: _textController,
                onChanged: provider.setText,
                decoration: const InputDecoration(
                  hintText: 'Enter your text here...',
                  prefixIcon: Icon(Icons.text_fields),
                ),
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),

              // Font Selector
              _buildSectionLabel('Font'),
              const SizedBox(height: 8),
              _buildFontSelector(provider, config),
              const SizedBox(height: 20),

              // Font Size Slider
              _buildSectionLabel('Font Size: ${config.fontSize.round()}'),
              Slider(
                value: config.fontSize,
                min: 12,
                max: 200,
                divisions: 188,
                onChanged: provider.setFontSize,
              ),
              const SizedBox(height: 16),

              // Text Color
              _buildSectionLabel('Text Color'),
              const SizedBox(height: 8),
              _buildColorSelector(provider, config),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildFontSelector(CardProvider provider, CardConfig config) {
    return Row(
      children: AppFont.values.map((font) {
        final isSelected = config.font == font;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => provider.setFont(font),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline.withAlpha((0.3 * 255).round()),
                    width: 2,
                  ),
                ),
                child: Text(
                  font.displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: font.fontFamily,
                    fontSize: 14,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorSelector(CardProvider provider, CardConfig config) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Preset colors
        ...AppColors.textColors.map((color) {
          final isSelected = config.textColor == color;
          return GestureDetector(
            onTap: () => provider.setTextColor(color),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : (color == Colors.white ? Colors.grey : Colors.transparent),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha((0.3 * 255).round()),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: color.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          );
        }),

        // Custom color picker
        GestureDetector(
          onTap: () => _showColorPicker(provider),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                colors: [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                  Colors.red,
                ],
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withAlpha((0.3 * 255).round()),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.colorize,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showColorPicker(CardProvider provider) async {
    Color pickedColor = provider.config.textColor;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            color: pickedColor,
            onColorChanged: (color) => pickedColor = color,
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.wheel: true,
              ColorPickerType.accent: false,
              ColorPickerType.primary: false,
            },
            enableShadesSelection: true,
            width: 44,
            height: 44,
            borderRadius: 22,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.setTextColor(pickedColor);
              Navigator.pop(context);
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveToGallery() async {
    setState(() => _isSaving = true);

    try {
      final bytes = await ImageService.captureWidget(_canvasKey);
      if (bytes != null) {
        final success = await ImageService.saveToGallery(bytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'Image saved to gallery!'
                    : 'Failed to save image. Please grant storage permission.',
              ),
              backgroundColor: success ? Colors.green : Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
