import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/typography.dart';
import 'package:qr_toolkit/shared/enums/qr_content_type.dart';
import 'package:qr_toolkit/features/create_qr/presentation/controller/create_qr_controller.dart';
import 'package:qr_toolkit/features/create_qr/presentation/widgets/type_form_fields.dart';

class CreateQrPage extends ConsumerStatefulWidget {
  const CreateQrPage({super.key});

  @override
  ConsumerState<CreateQrPage> createState() => _CreateQrPageState();
}

class _CreateQrPageState extends ConsumerState<CreateQrPage> {
  bool _showMore = false;

  static const List<QrContentType> _primaryTypes = [
    QrContentType.url,
    QrContentType.text,
    QrContentType.email,
    QrContentType.phone,
    QrContentType.sms,
    QrContentType.wifi,
    QrContentType.contact,
    QrContentType.geo,
    QrContentType.event,
  ];

  static const List<QrContentType> _moreTypes = [
    QrContentType.whatsapp,
    QrContentType.telegram,
    QrContentType.instagram,
    QrContentType.facebook,
    QrContentType.tiktok,
    QrContentType.youtube,
    QrContentType.linkedin,
    QrContentType.pdf,
    QrContentType.image,
    QrContentType.video,
    QrContentType.audio,
    QrContentType.custom,
  ];

  String _subtitleFor(QrContentType type) {
    switch (type) {
      case QrContentType.url:
        return 'https://example.com';
      case QrContentType.text:
        return 'Enter your text';
      case QrContentType.email:
        return 'name@example.com';
      case QrContentType.phone:
        return '+213 123 456 789';
      case QrContentType.sms:
        return 'Send a text message';
      case QrContentType.wifi:
        return 'Network configuration';
      case QrContentType.contact:
        return 'Save contact info';
      case QrContentType.geo:
        return 'Latitude, Longitude';
      case QrContentType.event:
        return 'Add to calendar';
      case QrContentType.whatsapp:
        return 'Send a WhatsApp message';
      case QrContentType.telegram:
        return 'Telegram username';
      case QrContentType.instagram:
        return 'Instagram profile';
      case QrContentType.facebook:
        return 'Facebook profile';
      case QrContentType.tiktok:
        return 'TikTok profile';
      case QrContentType.youtube:
        return 'YouTube channel';
      case QrContentType.linkedin:
        return 'LinkedIn profile';
      case QrContentType.pdf:
        return 'PDF file link';
      case QrContentType.image:
        return 'Image file link';
      case QrContentType.video:
        return 'Video file link';
      case QrContentType.audio:
        return 'Audio file link';
      case QrContentType.custom:
        return 'Custom raw content';
      case QrContentType.other:
        return 'Other content';
    }
  }

  void _onTypeTap(QrContentType type) {
    final controller = ref.read(createQrControllerProvider.notifier);
    controller.selectType(type);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.lightBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => _TypeBottomSheet(type: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleTypes = _showMore
        ? [..._primaryTypes, ..._moreTypes]
        : _primaryTypes;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Create QR',
          style: TextStyle(color: AppColors.lightTextPrimary),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              itemCount: visibleTypes.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: AppColors.lightTextSecondary.withOpacity(0.15),
              ),
              itemBuilder: (context, index) {
                final type = visibleTypes[index];
                return _QrTypeRow(
                  type: type,
                  subtitle: _subtitleFor(type),
                  onTap: () => _onTypeTap(type),
                );
              },
            ),
          ),
          if (!_showMore)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: AppRadius.pillRadius,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: AppRadius.pillRadius,
                    child: InkWell(
                      borderRadius: AppRadius.pillRadius,
                      onTap: () => setState(() => _showMore = true),
                      child: Center(
                        child: Text(
                          'View More QR Types',
                          style: AppTypography.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QrTypeRow extends StatelessWidget {
  const _QrTypeRow({
    required this.type,
    required this.subtitle,
    required this.onTap,
  });

  final QrContentType type;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightSurface,
      borderRadius: AppRadius.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(type.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.lightTextSecondary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeBottomSheet extends ConsumerStatefulWidget {
  const _TypeBottomSheet({required this.type});

  final QrContentType type;

  @override
  ConsumerState<_TypeBottomSheet> createState() => _TypeBottomSheetState();
}

class _TypeBottomSheetState extends ConsumerState<_TypeBottomSheet> {
  final _formKey = GlobalKey<TypeFormFieldsState>();

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(createQrControllerProvider.notifier);

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.lightTextSecondary.withOpacity(0.3),
                      borderRadius: AppRadius.pillRadius,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.type.icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      widget.type.label,
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.lightTextSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TypeFormFields(key: _formKey, type: widget.type),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: AppRadius.pillRadius,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: AppRadius.pillRadius,
                      child: InkWell(
                        borderRadius: AppRadius.pillRadius,
                        onTap: () {
                          final fields = _formKey.currentState?.collect() ?? {};
                          controller.updateFields(fields);
                          Navigator.pop(context);
                          context.push('/designer');
                        },
                        child: Center(
                          child: Text(
                            'Generate QR',
                            style: AppTypography.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
