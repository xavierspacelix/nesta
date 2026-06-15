import '../models/notification_type.dart';

abstract class INotificationService {
  Future<bool> requestPermission();
  Future<void> notify(NotificationType type, String title, String body);
  Future<void> scheduleDaily(NotificationType type, int hour, int minute, String title, String body);
  Future<void> cancelScheduled(NotificationType type);
}

class MockNotificationService implements INotificationService {
  final List<String> _log = [];

  @override
  Future<bool> requestPermission() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<void> notify(NotificationType type, String title, String body) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _log.add('[${type.label}] $title — $body');
    // ignore: avoid_print
    print('[MockNotification] ${_log.last}');
  }

  @override
  Future<void> scheduleDaily(
    NotificationType type,
    int hour,
    int minute,
    String title,
    String body,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _log.add('[${type.label}] Scheduled daily at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} — $title');
  }

  @override
  Future<void> cancelScheduled(NotificationType type) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _log.add('[${type.label}] Cancelled scheduled notifications');
  }
}
