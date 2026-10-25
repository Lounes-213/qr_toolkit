import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_toolkit/core/design_system/design_system.dart';
import 'package:qr_toolkit/core/services/update/update_model.dart';

/// Shown when the installed version is below the minimum allowed.
/// The user cannot continue past this screen.
class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key, required this.info});

  final VersionInfo info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.space5),
          child: Center(
            child: LiquidGlass(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                    ),
                    child: const Icon(Icons.system_update_alt,
                        size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: DesignTokens.space4),
                  Text(
                    'Update Required',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: DesignTokens.space2),
                  Text(
                    'This version is no longer supported. '
                    'Please update to continue using the app.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: DesignTokens.space5),
                  FilledButton.icon(
                    onPressed: () => _openStore(info.url),
                    icon: const Icon(Icons.download),
                    label: const Text('Update Now'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openStore(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
