import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity_item.dart';
import '../models/feed_item.dart';
import 'activity_repository.dart';

class SupabaseActivityRepository implements IActivityRepository {
  final SupabaseClient _client;

  SupabaseActivityRepository(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<String?> _getHouseId() async {
    final profile = await _client
        .from('profiles')
        .select('house_id')
        .eq('id', _userId)
        .maybeSingle();
    if (profile == null) return null;
    return profile['house_id'] as String?;
  }

  @override
  Future<List<ActivityItem>> getRecentActivities() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final response = await _client
          .from('activity_feed')
          .select('id, description, category, created_at')
          .eq('house_id', houseId)
          .or('target_user_id.is.null,target_user_id.eq.${_userId}')
          .order('created_at', ascending: false)
          .limit(5);

      return response.map((json) {
        final date = DateTime.parse(json['created_at'] as String);
        return ActivityItem(
          id: json['id'] as String,
          description: json['description'] as String,
          timeAgo: _timeAgo(date),
          type: json['category'] as String,
        );
      }).toList();
    } catch (e) {
      Log.e('ActivityRepo', 'getRecentActivities failed', e);
      rethrow;
    }
  }

  @override
  Future<List<FeedItem>> getFullFeed() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

    final response = await _client
        .from('activity_feed')
        .select('''
          id, description, category, created_at,
          profiles!activity_feed_user_id_fkey(name, nickname)
        ''')
          .eq('house_id', houseId)
          .or('target_user_id.is.null,target_user_id.eq.${_userId}')
          .order('created_at', ascending: false);

      return response.map((json) {
        final profile = json['profiles'] as Map;
        final userName = (profile['nickname'] as String?) ?? (profile['name'] as String? ?? 'Unknown').split(' ').first;
        final date = DateTime.parse(json['created_at'] as String);
        final categoryStr = json['category'] as String;

        FeedCategory category;
        switch (categoryStr) {
          case 'photo':
            category = FeedCategory.photo;
            break;
          case 'swap':
            category = FeedCategory.swap;
            break;
          case 'fine':
            category = FeedCategory.fine;
            break;
          default:
            category = FeedCategory.chore;
        }

        return FeedItem(
          id: json['id'] as String,
          userName: userName,
          userInitial: userName.isNotEmpty ? userName[0].toUpperCase() : '?',
          description: json['description'] as String,
          timestamp: date,
          category: category,
        );
      }).toList();
    } catch (e) {
      Log.e('ActivityRepo', 'getFullFeed failed', e);
      rethrow;
    }
  }

  @override
  Future<void> createActivity({
    required String houseId,
    required String userId,
    required String description,
    required String category,
    String? targetUserId,
  }) async {
    try {
      await _client.from('activity_feed').insert({
        'house_id': houseId,
        'user_id': userId,
        'description': description,
        'target_user_id': targetUserId,
        'category': category,
      });
    } catch (e) {
      Log.e('ActivityRepo', 'createActivity failed', e);
      rethrow;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
    if (diff.inDays < 2) return 'Kemarin';
    return '${diff.inDays} hari yang lalu';
  }
}
