import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/typography.dart';

class ScanResultPage extends StatefulWidget {
  const ScanResultPage({
    super.key,
    required this.content,
    required this.type,
    this.scanId,
  });

  final String content;
  final String type;
  final String? scanId;

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  bool _isFavorite = false;

  bool get _isUrl =>
      widget.type.toLowerCase() == 'url' ||
      widget.content.toLowerCase().startsWith('http://') ||
      widget.content.toLowerCase().startsWith('https://');

  String get _title {
    final type = widget.type.toLowerCase();
    if (type == 'url') return 'Website URL';
    if (type == 'text') return 'Text';
    if (type == 'email') return 'Email Address';
    if (type == 'phone') return 'Phone Number';
    if (type == 'wifi') return 'WiFi Network';
    if (type == 'contact') return 'Contact';
    if (type == 'location') return 'Location';
    return widget.type;
  }

  String get _description {
    if (_isUrl) return 'This link leads to a website';
    if (widget.type.toLowerCase() == 'text') return 'Plain text content';
    if (widget.type.toLowerCase() == 'email') return 'An email address';
    if (widget.type.toLowerCase() == 'phone') return 'A phone number';
    if (widget.type.toLowerCase() == 'wifi') return 'WiFi network credentials';
    if (widget.type.toLowerCase() == 'contact') return 'Contact information';
    if (widget.type.toLowerCase() == 'location') return 'A geographic location';
    return 'Scanned content';
  }

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.content);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied to clipboard',
          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.smRadius),
      ),
    );
  }

  void _shareContent() {
    Share.share(widget.content);
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _title,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.lightTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildQrImage(),
            const SizedBox(height: AppSpacing.lg),
            _buildContentSection(),
            const SizedBox(height: AppSpacing.lg),
            _buildActionButtons(),
            const SizedBox(height: AppSpacing.md),
            _buildSecondaryButtons(),
            const SizedBox(height: AppSpacing.lg),
            _buildSafeBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildQrImage() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: AppRadius.lgRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.withOpacity(Colors.black, 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: QrImageView(
        data: widget.content,
        version: QrVersions.auto,
        size: 200,
        backgroundColor: Colors.white,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: AppColors.primary,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: AppColors.lightTextPrimary,
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.withOpacity(AppColors.primary, 0.1),
            borderRadius: AppRadius.pillRadius,
          ),
          child: Text(
            _title,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          widget.content,
          textAlign: TextAlign.center,
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _description,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (_isUrl)
          Expanded(
            child: _primaryButton(
              label: 'Open',
              icon: Icons.open_in_new_rounded,
              onTap: _launchUrl,
            ),
          ),
        if (_isUrl) const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _outlinedButton(
            label: 'Copy',
            icon: Icons.copy_rounded,
            onTap: _copyToClipboard,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _outlinedButton(
            label: 'Share',
            icon: Icons.share_rounded,
            onTap: _shareContent,
          ),
        ),
      ],
    );
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlinedButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(
            color: AppColors.withOpacity(AppColors.lightTextPrimary, 0.15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.lightTextPrimary,
              size: 18,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButtons() {
    return Column(
      children: [
        _fullWidthButton(
          label: 'Save',
          icon: Icons.bookmark_outline_rounded,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Saved to history',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.smRadius,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _fullWidthButton(
          label: 'Add to Favorites',
          icon: _isFavorite
              ? Icons.star_rounded
              : Icons.star_outline_rounded,
          iconColor: _isFavorite ? AppColors.warning : null,
          onTap: _toggleFavorite,
        ),
      ],
    );
  }

  Widget _fullWidthButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(
            color: AppColors.withOpacity(AppColors.lightTextPrimary, 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.lightTextPrimary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(AppColors.success, 0.1),
        borderRadius: AppRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: 18,
            color: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Safe & Secure',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
