import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String githubRepoUrl = 'https://github.com/Maksaline/Shadhinota-Canvas-2026';
  static const String developerPortfolioUrl = 'https://maksaline.com';
  static const String developerGithubUrl = 'https://github.com/Maksaline/';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(fontFamily: 'Hadi'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.bloodRed.withAlpha((0.2 * 255).round()),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'স্বাধীনতা ক্যানভাস',
              style: TextStyle(
                fontFamily: 'AbuSayed',
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Shadhinota Canvas',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 0.1.0',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withAlpha((0.5 * 255).round()),
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'A photo card generation app to raise your voice visually against injustice. Create beautiful cards with custom backgrounds, text overlays, and bold fonts like Hadi and Abu Sayed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha((0.8 * 255).round()),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(context, 'This app is dedicated to martyr Sharif Osman Bin Hadi vai...'),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.code),
                const SizedBox(width: 8),
                Text('Open Source under MIT license.'),
              ],
            ),
            _buildLinkCard(
              context,
              icon: Bootstrap.github,
              title: 'GitHub Repository',
              subtitle: 'View source code & contribute',
              url: githubRepoUrl,
            ),
            const SizedBox(height: 32),

            Text('Developed by'),
            Text('Maksaline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            _buildLinkCard(
              context,
              icon: Bootstrap.globe,
              title: 'Maksaline.com',
              subtitle: 'Visit my portfolio website',
              url: developerPortfolioUrl,
            ),
            const SizedBox(height: 12),
            _buildLinkCard(
              context,
              icon: Bootstrap.github,
              title: 'GitHub Profile',
              subtitle: 'Follow on GitHub',
              url: developerGithubUrl,
            ),
            const SizedBox(height: 32),

            Text(
              'Made with ❤️ for my country',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withAlpha((0.5 * 255).round()),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.bloodRed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bloodRed.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDark ? AppColors.lightBloodRed : AppColors.bloodRed,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withAlpha((0.4 * 255).round()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
