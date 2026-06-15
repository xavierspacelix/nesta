import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity_item.dart';
import '../models/feed_item.dart';
import '../repositories/activity_repository.dart';
import '../repositories/supabase_activity_repository.dart';

final activityRepositoryProvider = Provider<IActivityRepository>((ref) {
  return SupabaseActivityRepository(Supabase.instance.client);
});

final recentActivityProvider = AsyncNotifierProvider<RecentActivityNotifier, List<ActivityItem>>(() {
  return RecentActivityNotifier();
});

class RecentActivityNotifier extends AsyncNotifier<List<ActivityItem>> {
  @override
  Future<List<ActivityItem>> build() async {
    final repository = ref.watch(activityRepositoryProvider);
    return repository.getRecentActivities();
  }
}

final activityFeedProvider = FutureProvider<List<FeedItem>>((ref) {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getFullFeed();
});
