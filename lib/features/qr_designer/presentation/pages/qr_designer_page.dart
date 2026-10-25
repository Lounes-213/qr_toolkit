import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/typography.dart';
import 'package:qr_toolkit/shared/models/qr_model.dart';
import 'package:qr_toolkit/shared/enums/qr_content_type.dart';
import 'package:qr_toolkit/features/qr_designer/presentation/widgets/live_preview.dart';
import 'package:qr_toolkit/features/qr_designer/presentation/widgets/eye_style_selector.dart';
import 'package:qr_toolkit/features/qr_designer/presentation/widgets/dot_style_selector.dart';
import 'package:qr_toolkit/features/qr_designer/presentation/widgets/frame_selector.dart';
import 'package:qr_toolkit/features/qr_designer/presentation/widgets/background_selector.dart';
import 'package:qr_toolkit/features/export/presentation/widgets/export_menu.dart';

class QrDesignerPage extends StatefulWidget {
  const QrDesignerPage({super.key, this.initial});

  final QrModel? initial;

  @override
  State<QrDesignerPage> createState() => _QrDesignerPageState();
}

class _QrDesignerPageState extends State<QrDesignerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late QrModel _currentModel;
  final GlobalKey _qrPreviewKey = GlobalKey();

  final List<Map<String, dynamic>> _colorOptions = [
    {'color': const Color(0xFFE74C3C), 'name': 'Red'},
    {'color': const Color(0xFFE91E8A), 'name': 'Pink'},
    {'color': const Color(0xFF6C5CE7), 'name': 'Purple'},
    {'color': const Color(0xFF3498DB), 'name': 'Blue'},
    {'color': const Color(0xFF2ECC71), 'name': 'Green'},
    {'color': const Color(0xFFF39C12), 'name': 'Orange'},
  ];

  final List<String> _tabs = ['Style', 'Eyes', 'Dots', 'Logo', 'Frame'];
  Color _selectedColor = AppColors.primary;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _currentModel = widget.initial ??
        const QrModel(content: 'https://qr-toolkit.app', type: QrContentType.url);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateModel(QrModel updated) {
    setState(() => _currentModel = updated);
  }

  void _showExportMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ExportMenu(
          model: _currentModel,
          capture: ({bool highRes = false}) =>
              _qrPreviewKey.capture(highRes: highRes),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.lightTextPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('QR Designer', style: AppTypography.titleLarge.copyWith(
          color: AppColors.lightTextPrimary,
        )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 24),
            onPressed: () => Navigator.pop(context, _currentModel),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  _buildQrPreview(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTabBar(),
                  _buildTabContent(),
                ],
              ),
            ),
          ),
          _buildExportSection(),
        ],
      ),
    );
  }

  Widget _buildQrPreview() {
    return Center(
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.lgRadius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: RepaintBoundary(
          key: _qrPreviewKey,
          child: ClipRRect(
            borderRadius: AppRadius.lgRadius,
            child: LivePreview(model: _currentModel),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _tabController.index == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _tabController.index = index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: AppRadius.smRadius,
                ),
                child: Center(
                  child: Text(
                    _tabs[index],
                    style: AppTypography.labelMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_tabController.index) {
      case 0:
        return _buildStyleTab();
      case 1:
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: EyeStyleSelector(
            selected: _currentModel.eyeStyle,
            onSelected: (v) => setState(() => _currentModel = _currentModel.copyWith(eyeStyle: v)),
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: DotStyleSelector(
            selected: _currentModel.dotStyle,
            onSelected: (v) => setState(() => _currentModel = _currentModel.copyWith(dotStyle: v)),
          ),
        );
      case 3:
        return _buildLogoTab();
      case 4:
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FrameSelector(
            selected: 'none',
            onSelected: (_) {},
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStyleTab() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Color'),
          const SizedBox(height: AppSpacing.sm),
          _buildColorSelector(),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionTitle('Background'),
          const SizedBox(height: AppSpacing.sm),
          BackgroundSelector(
            selected: _currentModel.backgroundColor,
            onSelected: (c) =>
                setState(() => _currentModel = _currentModel.copyWith(backgroundColor: c)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTypography.labelMedium.copyWith(
      color: AppColors.lightTextSecondary,
      fontWeight: FontWeight.w600,
    ));
  }

  Widget _buildColorSelector() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _colorOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm + 4),
        itemBuilder: (context, index) {
          final colorData = _colorOptions[index];
          final color = colorData['color'] as Color;
          final isSelected = _selectedColor.toARGB32() == color.toARGB32();
          return GestureDetector(
            onTap: () {
              setState(() => _selectedColor = color);
              _updateModel(_currentModel.copyWith(color: color.toARGB32()));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: AppColors.lightSurface, width: 3)
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoTab() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Logo'),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.lightSurfaceVariant,
                borderRadius: AppRadius.mdRadius,
                border: Border.all(
                  color: AppColors.lightTextSecondary,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 36,
                    color: AppColors.lightTextSecondary,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Add Logo',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showExportMenu,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.mdRadius,
              ),
              elevation: 0,
            ),
            child: const Text('Export QR'),
          ),
        ),
      ),
    );
  }
}
