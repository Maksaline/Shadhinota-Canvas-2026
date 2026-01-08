import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../models/card_config.dart';
import '../providers/card_provider.dart';
import '../providers/theme_provider.dart';
import '../services/image_service.dart';
import 'editor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // List of template images
  static const List<String> templates = [
    'bg/3F-dark-red.png',
    'bg/3F-dark-white-8.png',
    'bg/army-white.png',
    'bg/codepotro-protest-poster_2025_04_13T17_43_13_399Z.png',
    'bg/codepotro-protest-poster_2025_04_13T17_43_15_831Z.png',
    'bg/codepotro-protest-poster_2025_04_13T17_43_21_089Z.png',
    'bg/horse-black.png',
    'bg/horse-red.png',
    'bg/horse-white.png',
    'bg/red-army.png',
    'bg/rpg-green.png',
    'bg/rpg-red.png',
    'bg/salahuddin.png',
    'bg/shahadha-black.png',
    'bg/shahadha-red-8.png',
    'bg/shahadha-white.png',
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final cardProvider = context.read<CardProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'স্বাধীনতা ক্যানভাস',
          style: TextStyle(fontFamily: 'AbuSayed'),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildSectionHeader(
              context,
              'Create Your Card',
              Icons.brush,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a canvas to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha((0.7 * 255).round()),
                  ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(context, cardProvider),
            const SizedBox(height: 32),

            // Color Canvas Section
            _buildSectionHeader(context, 'Solid Colors', Icons.palette),
            const SizedBox(height: 12),
            _buildColorGrid(context, cardProvider),
            const SizedBox(height: 32),

            // Template Section
            _buildSectionHeader(context, 'Templates', Icons.grid_view),
            const SizedBox(height: 12),
            _buildTemplateGrid(context, cardProvider),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, CardProvider cardProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.photo_library,
            label: 'Gallery',
            onTap: () => _pickFromGallery(context, cardProvider),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.camera_alt,
            label: 'Camera',
            onTap: () => _captureFromCamera(context, cardProvider),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha((0.1 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorGrid(BuildContext context, CardProvider cardProvider) {
    final colors = [...AppColors.canvasColors];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: colors.length + 1, // +1 for color picker
      itemBuilder: (context, index) {
        // Last item is the color picker
        if (index == colors.length) {
          return _buildCustomColorPicker(context, cardProvider);
        }
        
        final color = colors[index];
        return GestureDetector(
          onTap: () {
            cardProvider.setColorCanvas(color);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditorScreen()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color == Colors.white
                    ? Colors.grey[300]!
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha((0.3 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomColorPicker(BuildContext context, CardProvider cardProvider) {
    return GestureDetector(
      onTap: () => _showCanvasColorPicker(context, cardProvider),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withAlpha((0.3 * 255).round()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.colorize,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Future<void> _showCanvasColorPicker(BuildContext context, CardProvider cardProvider) async {
    Color pickedColor = AppColors.bloodRed;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick Canvas Color'),
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
              Navigator.pop(context);
              cardProvider.setColorCanvas(pickedColor);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditorScreen()),
              );
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateGrid(BuildContext context, CardProvider cardProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return GestureDetector(
          onTap: () {
            cardProvider.setTemplateCanvas(template);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditorScreen()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                template,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFromGallery(
      BuildContext context, CardProvider cardProvider) async {
    final bytes = await ImageService.pickFromGallery();
    if (bytes != null && context.mounted) {
      cardProvider.setImageCanvas(bytes, CanvasType.gallery);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditorScreen()),
      );
    }
  }

  Future<void> _captureFromCamera(
      BuildContext context, CardProvider cardProvider) async {
    final bytes = await ImageService.captureFromCamera();
    if (bytes != null && context.mounted) {
      cardProvider.setImageCanvas(bytes, CanvasType.camera);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditorScreen()),
      );
    }
  }
}
