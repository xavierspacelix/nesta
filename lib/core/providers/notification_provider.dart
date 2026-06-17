import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/device_token_repository.dart';
import '../services/fcm_notification_service.dart';
import '../services/notification_service.dart';
import '../services/push_notification_sender.dart';

final deviceTokenRepositoryProvider = Provider<IDeviceTokenRepository>((ref) {
  return SupabaseDeviceTokenRepository(Supabase.instance.client);
});

final fcmNotificationServiceProvider = Provider<FCMNotificationService>((ref) {
  final repo = ref.read(deviceTokenRepositoryProvider);
  final service = FCMNotificationService(tokenRepo: repo);
  service.init();
  return service;
});

final pushNotificationSenderProvider = Provider<PushNotificationSender>((ref) {
  return PushNotificationSender(Supabase.instance.client);
});

final notificationServiceProvider = Provider<INotificationService>((ref) {
  return ref.read(fcmNotificationServiceProvider);
});

final notificationEnabledProvider = NotifierProvider<NotificationEnabledNotifier, bool>(
  NotificationEnabledNotifier.new,
);

class NotificationEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}
