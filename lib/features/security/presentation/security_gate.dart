import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/core/security/models/security_report.dart';
import 'package:qr_toolkit/features/security/presentation/pages/security_blocked_page.dart';
import 'package:qr_toolkit/features/security/security_provider.dart';

/// Blocks the app in release builds when a critical issue is detected.
class SecurityGate extends ConsumerStatefulWidget {
  const SecurityGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<SecurityGate> createState() => _SecurityGateState();
}

class _SecurityGateState extends ConsumerState<SecurityGate> {
  bool _blocked = false;
  String _reason = '';

  @override
  void initState() {
    super.initState();
    ref.read(securityReportProvider.future).then(_handle, onError: (_) {});
  }

  void _handle(SecurityReport report) {
    if (!mounted) return;
    if (kReleaseMode && report.isCritical) {
      final reasons = <String>[];
      if (report.isRooted) reasons.add('Rooted device detected.');
      if (report.isTampered) reasons.add('App integrity compromised.');
      if (report.isDebuggerAttached) reasons.add('Debugger attached.');
      setState(() {
        _blocked = true;
        _reason = reasons.join(' ');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_blocked) return SecurityBlockedPage(reason: _reason);
    return widget.child;
  }
}
