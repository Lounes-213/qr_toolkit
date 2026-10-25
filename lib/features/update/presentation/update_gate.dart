import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/core/services/update/update_model.dart';
import 'package:qr_toolkit/features/update/presentation/pages/force_update_page.dart';
import 'package:qr_toolkit/features/update/presentation/widgets/update_available_dialog.dart';
import 'package:qr_toolkit/features/update/update_provider.dart';

/// Gates the whole app behind the version check performed on startup.
class UpdateGate extends ConsumerStatefulWidget {
  const UpdateGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends ConsumerState<UpdateGate> {
  bool _forceUpdate = false;
  VersionInfo? _forceInfo;

  @override
  void initState() {
    super.initState();
    ref.read(updateCheckProvider.future).then(_handle, onError: (_) {});
  }

  void _handle(UpdateCheckResult result) {
    if (!mounted) return;
    if (result.mustForce) {
      setState(() {
        _forceUpdate = true;
        _forceInfo = result.info;
      });
    } else if (result.canUpdate && result.info != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showUpdateAvailableDialog(context, result.info!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_forceUpdate && _forceInfo != null) {
      return ForceUpdatePage(info: _forceInfo!);
    }
    return widget.child;
  }
}
