import 'package:equatable/equatable.dart';

class SecurityReport extends Equatable {
  const SecurityReport({
    required this.isRooted,
    required this.isEmulator,
    required this.isDebugBuild,
    required this.isTampered,
    required this.isDebuggerAttached,
  });

  final bool isRooted;
  final bool isEmulator;
  final bool isDebugBuild;
  final bool isTampered;
  final bool isDebuggerAttached;

  /// Critical issues that should block the app in release builds.
  bool get isCritical => (isRooted || isTampered || isDebuggerAttached);

  @override
  List<Object> get props => [
        isRooted,
        isEmulator,
        isDebugBuild,
        isTampered,
        isDebuggerAttached,
      ];
}
