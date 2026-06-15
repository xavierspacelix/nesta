import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/analytics_data.dart';
import '../repositories/analytics_repository.dart';
import '../repositories/supabase_analytics_repository.dart';

final analyticsRepositoryProvider = Provider<IAnalyticsRepository>((ref) {
  return SupabaseAnalyticsRepository(Supabase.instance.client);
});

final analyticsProvider = FutureProvider<AnalyticsData>((ref) {
  return ref.watch(analyticsRepositoryProvider).getAnalytics();
});
