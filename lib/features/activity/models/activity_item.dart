import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_item.freezed.dart';
part 'activity_item.g.dart';

@freezed
abstract class ActivityItem with _$ActivityItem {
  const factory ActivityItem({
    required String id,
    required String description,
    required String timeAgo,
    required String type,
  }) = _ActivityItem;

  factory ActivityItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityItemFromJson(json);
}
