import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_toolkit/core/design_system/design_system.dart';
import 'package:qr_toolkit/core/services/update/update_model.dart';

/// Soft "update available" dialog. User may skip or update.
Future<void> showUpdateAvailableDialog(
  BuildContext context,
  VersionInfo info,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      ),
      title: const Text('Update Available'),
      content: Text(
        'A new version (${info.latestVersion}) is available. '
        'Update for the best experience.',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Skip'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            final uri = Uri.parse(info.url);
            if (info.url.isNotEmpty) launchUrl(uri);
          },
          child: const Text('Update'),
        ),
      ],
    ),
  );
}
