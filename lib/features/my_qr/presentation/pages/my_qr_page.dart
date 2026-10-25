import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/typography.dart';
import 'package:qr_flutter/qr_flutter.dart';

class _QrItem {
  const _QrItem({
    required this.title,
    required this.subtitle,
    required this.data,
    required this.time,
    required this.filterTag,
  });

  final String title;
  final String subtitle;
  final String data;
  final String time;
  final String filterTag;
}

class MyQrPage extends StatefulWidget {
  const MyQrPage({super.key});

  @override
  State<MyQrPage> createState() => _MyQrPageState();
}

class _MyQrPageState extends State<MyQrPage> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  static const _filters = ['All', 'Website', 'WiFi', 'Contact', 'Payment'];

  static const _demoData = [
    _QrItem(
      title: 'My Website',
      subtitle: 'Personal portfolio',
      data: 'https://example.com',
      time: '2 min ago',
      filterTag: 'Website',
    ),
    _QrItem(
      title: 'Office WiFi',
      subtitle: 'WPA2 network',
      data: 'WIFI:T:WPA;S:OfficeNet;P:secret123;;',
      time: '15 min ago',
      filterTag: 'WiFi',
    ),
    _QrItem(
      title: 'John Doe',
      subtitle: 'Contact card',
      data: 'BEGIN:VCARD\nVERSION:3.0\nFN:John Doe\nEND:VCARD',
      time: '1 hour ago',
      filterTag: 'Contact',
    ),
    _QrItem(
      title: 'Payment Link',
      subtitle: 'Invoice #1042',
      data: 'https://pay.example.com/invoice/1042',
      time: '2 hours ago',
      filterTag: 'Payment',
    ),
    _QrItem(
      title: 'Portfolio Site',
      subtitle: 'Design showcase',
      data: 'https://portfolio.example.com',
      time: '3 hours ago',
      filterTag: 'Website',
    ),
    _QrItem(
      title: 'Cafe WiFi',
      subtitle: 'Open network',
      data: 'WIFI:T:WPA;S:CafeConnect;P:coffee2024;;',
      time: '5 hours ago',
      filterTag: 'WiFi',
    ),
    _QrItem(
      title: 'Jane Smith',
      subtitle: 'Business card',
      data: 'BEGIN:VCARD\nVERSION:3.0\nFN:Jane Smith\nEND:VCARD',
      time: 'Yesterday',
      filterTag: 'Contact',
    ),
    _QrItem(
      title: 'Subscription',
      subtitle: 'Monthly plan',
      data: 'https://pay.example.com/subscription/monthly',
      time: 'Yesterday',
      filterTag: 'Payment',
    ),
  ];

  List<_QrItem> get _filteredItems {
    return _demoData.where((item) {
      final matchesFilter =
          _selectedFilter == 'All' || item.filterTag == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My QR Library',
          style: TextStyle(color: AppColors.lightTextPrimary),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: AppColors.lightTextPrimary),
              decoration: InputDecoration(
                hintText: 'Search QR codes...',
                hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.lightTextSecondary),
                filled: true,
                fillColor: AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.mdRadius,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.mdRadius,
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 4,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: _filters.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final selected = _selectedFilter == filter;
                return FilterChip(
                  label: Text(filter),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selectedFilter = filter),
                  selectedColor: AppColors.primary,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: AppColors.lightSurface,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.pillRadius,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 64,
                          color: AppColors.lightTextSecondary.withOpacity(0.4),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No QR codes found',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        _QrGridCard(item: items[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class _QrGridCard extends StatelessWidget {
  const _QrGridCard({required this.item});

  final _QrItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: AppRadius.mdRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: QrImageView(
                    data: item.data,
                    version: QrVersions.auto,
                    size: 90,
                    backgroundColor: Colors.white,
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: AppColors.lightTextPrimary,
                    ),
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: Text(
              item.time,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.lightTextSecondary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
