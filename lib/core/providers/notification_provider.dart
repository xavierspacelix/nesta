import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

final notificationServiceProvider = Provider<INotificationService>((ref) {
  return MockNotificationService();
});

final notificationEnabledProvider = NotifierProvider<NotificationEnabledNotifier, bool>(
  NotificationEnabledNotifier.new,
);

class NotificationEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}
