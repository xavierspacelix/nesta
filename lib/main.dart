import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/router/app_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/models/notification_type.dart';
import 'package:nesta/core/services/notification_service.dart';
import 'package:nesta/core/services/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  _initNotifications();
  runApp(
    const ProviderScope(
      child: NestaApp(),
    ),
  );
}

void _initNotifications() {
  final notificationService = MockNotificationService();
  notificationService.requestPermission();
  notificationService.scheduleDaily(
    NotificationType.dutyReminder,
    8, 0, 'Pengingat Piket',
    'Jangan lupa tugas piket hari ini!',
  );
  notificationService.scheduleDaily(
    NotificationType.dueSoon,
    18, 0, 'Piket Hampir Berakhir',
    'Selesaikan tugas piket sebelum tengah malam!',
  );
  notificationService.scheduleDaily(
    NotificationType.missedDuty,
    22, 0, 'Piket Terlewat',
    'Sayang sekali, tugas piket hari ini terlewat.',
  );
}

class NestaApp extends StatelessWidget {
  const NestaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nesta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
