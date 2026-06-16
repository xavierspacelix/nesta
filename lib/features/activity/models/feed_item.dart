import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_item.freezed.dart';
part 'feed_item.g.dart';

@freezed
abstract class FeedItem with _$FeedItem {
  const factory FeedItem({
    required String id,
    required String userName,
    required String userInitial,
    required String description,
    required DateTime timestamp,
    required FeedCategory category,
  }) = _FeedItem;
  const FeedItem._();

  factory FeedItem.fromJson(Map<String, dynamic> json) =>
      _$FeedItemFromJson(json);

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp.toLocal());
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
    if (diff.inDays < 2) return 'Kemarin';
    return '${diff.inDays} hari yang lalu';
  }
}

enum FeedCategory { chore, photo, swap, fine }
