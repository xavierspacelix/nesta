import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import '../models/notification_type.dart';
import '../repositories/device_token_repository.dart';
import 'notification_service.dart';

class FCMNotificationService implements INotificationService {
  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _local;
  final IDeviceTokenRepository _tokenRepo;

  FCMNotificationService({
    required this._tokenRepo,
    FirebaseMessaging? fcm,
    FlutterLocalNotificationsPlugin? local,
  })  : _fcm = fcm ?? FirebaseMessaging.instance,
        _local = local ?? FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzData.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _local.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    await requestPermission();

    final token = await _fcm.getToken();
    if (token != null) {
      await _tokenRepo.upsert(token, Platform.operatingSystem);
    }

    _fcm.onTokenRefresh.listen((token) {
      _tokenRepo.upsert(token, Platform.operatingSystem);
    });

    FirebaseMessaging.onMessage.listen(handleForegroundMessage);

    scheduleDaily(
      NotificationType.dutyReminder, 8, 0,
      'Pengingat Piket',
      'Jangan lupa tugas piket hari ini!',
    );
    scheduleDaily(
      NotificationType.dueSoon, 18, 0,
      'Piket Hampir Berakhir',
      'Selesaikan tugas piket sebelum tengah malam!',
    );
    scheduleDaily(
      NotificationType.missedDuty, 22, 0,
      'Piket Terlewat',
      'Sayang sekali, tugas piket hari ini terlewat.',
    );
  }

  @override
  Future<bool> requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<void> notify(NotificationType type, String title, String body) async {
    await _local.show(
      type.index,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'nesta_channel',
          'Nesta Notifications',
          channelDescription: 'Notifikasi dari aplikasi Nesta',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  @override
  Future<void> scheduleDaily(
    NotificationType type,
    int hour,
    int minute,
    String title,
    String body,
  ) async {
    final now = DateTime.now();
    final location = tz.local;
    var scheduledDate = tz.TZDateTime(location, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _local.zonedSchedule(
      type.index,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'nesta_daily_channel',
          'Pengingat Harian',
          channelDescription: 'Pengingat tugas harian Nesta',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelScheduled(NotificationType type) async {
    await _local.cancel(type.index);
  }

  void handleForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title ?? message.data['title'] ?? '';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    if (title.isNotEmpty && body.isNotEmpty) {
      _local.show(
        DateTime.now().millisecondsSinceEpoch % 100000,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'nesta_channel',
            'Nesta Notifications',
            channelDescription: 'Notifikasi dari aplikasi Nesta',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }
}
