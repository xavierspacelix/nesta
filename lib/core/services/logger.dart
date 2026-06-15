import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Log {
  static bool _enabled = true;

  static void enable() => _enabled = true;
  static void disable() => _enabled = false;

  static void _log(LogLevel level, String tag, String message, [Object? error, StackTrace? stack]) {
    if (!_enabled) return;

    final now = DateTime.now();
    final ts =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';

    final prefix = switch (level) {
      LogLevel.debug => '🔍 D',
      LogLevel.info => 'ℹ️  I',
      LogLevel.warning => '⚠️  W',
      LogLevel.error => '❌ E',
    };

    final buf = StringBuffer()
      ..write('$prefix [$ts] [$tag] $message');

    if (error != null) {
      buf.write(' → $error');
    }

    if (level == LogLevel.error && stack != null) {
      final frames = stack.toString().split('\n').take(4).join('\n    ');
      buf.write('\n    $frames');
    }

    debugPrint(buf.toString());
  }

  static void d(String tag, String message) => _log(LogLevel.debug, tag, message);
  static void i(String tag, String message) => _log(LogLevel.info, tag, message);
  static void w(String tag, String message) => _log(LogLevel.warning, tag, message);
  static void e(String tag, String message, [Object? error, StackTrace? stack]) =>
      _log(LogLevel.error, tag, message, error, stack);
}
