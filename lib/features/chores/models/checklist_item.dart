import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_item.freezed.dart';
part 'checklist_item.g.dart';

@freezed
abstract class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String id,
    required String title,
    required String roomId,
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);
}
