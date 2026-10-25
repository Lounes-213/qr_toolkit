import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_toolkit/core/constants/app_constants.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/typography.dart';
import 'package:qr_toolkit/features/settings/presentation/controller/settings_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: AppConstants.appName,
    packageName: '',
    version: AppConstants.appVersion,
    buildNumber: '',
  );

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _packageInfo = info);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  Future<void> _toggleBiometric(bool enabled) async {
    if (enabled) {
      final auth = LocalAuthentication();
      try {
        final canCheck = await auth.canCheckBiometrics;
        if (!canCheck && !await auth.isDeviceSupported()) {
          _showInfo(
            'Biometric authentication is not available on this device.',
          );
          return;
        }
        final didAuth = await auth.authenticate(
          localizedReason: 'Verify your identity to enable biometric lock',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        if (!didAuth) {
          _showInfo('Biometric verification failed.');
          return;
        }
      } catch (e) {
        _showInfo('Biometric verification failed: $e');
        return;
      }
    }
    await ref.read(settingsControllerProvider.notifier).setBiometric(enabled);
  }

  void _showInfo(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _showComingSoon() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coming soon!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.lightTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        children: [
          _sectionHeader('APPEARANCE'),
          _settingsCard(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.withOpacity(AppColors.primary, 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.dark_mode, color: AppColors.primary, size: 22),
                ),
                title: Text(
                  'Dark Mode',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                value: state.themeMode != ThemeMode.light,
                activeColor: AppColors.primary,
                onChanged: (on) => ref
                    .read(settingsControllerProvider.notifier)
                    .setThemeMode(on ? ThemeMode.dark : ThemeMode.light),
              ),
              const Divider(height: 1, color: AppColors.lightSurfaceVariant),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.withOpacity(AppColors.primary, 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.language, color: AppColors.primary, size: 22),
                ),
                title: Text(
                  'Language',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _languageLabel(state.languageCode),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.lightTextSecondary,
                      size: 20,
                    ),
                  ],
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.lightSurface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg),
                      ),
                    ),
                    builder: (ctx) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.lightTextSecondary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Select Language',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _languageOption(ctx, 'en', 'English', state.languageCode, ref),
                          _languageOption(ctx, 'fr', 'Français', state.languageCode, ref),
                          _languageOption(ctx, 'ar', 'العربية', state.languageCode, ref),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _sectionHeader('BACKUP & SYNC'),
          _settingsCard(
            children: [
              _chevronRow(
                icon: Icons.cloud_outlined,
                title: 'Cloud Backup',
                onTap: _showComingSoon,
              ),
              const Divider(height: 1, color: AppColors.lightSurfaceVariant),
              _chevronRow(
                icon: Icons.add_to_drive,
                title: 'Google Drive',
                trailingText: 'Connect',
                onTap: _showComingSoon,
              ),
              const Divider(height: 1, color: AppColors.lightSurfaceVariant),
              _chevronRow(
                icon: Icons.cloud,
                title: 'iCloud',
                trailingText: 'Connect',
                onTap: _showComingSoon,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _sectionHeader('SECURITY'),
          _settingsCard(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.withOpacity(AppColors.primary, 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.face, color: AppColors.primary, size: 22),
                ),
                title: Text(
                  'Face ID',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                value: state.biometricEnabled,
                activeColor: AppColors.primary,
                onChanged: _toggleBiometric,
              ),
              const Divider(height: 1, color: AppColors.lightSurfaceVariant),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.withOpacity(AppColors.primary, 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.lock_outline, color: AppColors.primary, size: 22),
                ),
                title: Text(
                  'App Lock',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                value: state.biometricEnabled,
                activeColor: AppColors.primary,
                onChanged: _toggleBiometric,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _sectionHeader('ABOUT'),
          _settingsCard(
            children: [
              _chevronRow(
                icon: Icons.star_rate,
                title: 'Rate Us',
                onTap: () => _launchUrl(AppConstants.rateAppUrl),
              ),
              const Divider(height: 1, color: AppColors.lightSurfaceVariant),
              _chevronRow(
                icon: Icons.info_outline,
                title: 'About QR Toolkit',
                trailingText: 'v${_packageInfo.version}',
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.lightSurface,
                      title: Text(
                        _packageInfo.appName,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      content: Text(
                        'Version ${_packageInfo.version} (${_packageInfo.buildNumber})\n\n'
                        'A modern QR code scanner, generator and designer.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        bottom: AppSpacing.sm,
        top: AppSpacing.xs,
      ),
      child: Text(
        title,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.lightTextSecondary,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _chevronRow({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.withOpacity(AppColors.primary, 0.15),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightTextPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.lightTextSecondary,
              ),
            ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.chevron_right,
            color: AppColors.lightTextSecondary,
            size: 20,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _languageOption(
    BuildContext ctx,
    String code,
    String label,
    String currentCode,
    WidgetRef ref,
  ) {
    final selected = currentCode == code;
    return ListTile(
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          color: selected ? AppColors.primary : AppColors.lightTextPrimary,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check, color: AppColors.primary, size: 22)
          : null,
      onTap: () {
        ref.read(settingsControllerProvider.notifier).setLanguage(code);
        Navigator.of(ctx).pop();
      },
    );
  }

  String _languageLabel(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      default:
        return code;
    }
  }
}
