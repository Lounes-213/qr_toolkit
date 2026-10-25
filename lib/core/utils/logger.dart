import 'dart:developer' as dev;

class AppLogger {
  AppLogger._();

  static void info(String message) => dev.log(message, name: 'INFO');
  static void error(String message, [Object? error, StackTrace? stack]) =>
      dev.log(message, name: 'ERROR', error: error, stackTrace: stack);
  static void debug(String message) => dev.log(message, name: 'DEBUG');
}
