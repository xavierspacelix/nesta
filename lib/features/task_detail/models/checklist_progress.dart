import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_progress.freezed.dart';
part 'checklist_progress.g.dart';

@freezed
abstract class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String id,
    required String name,
    @Default(false) bool isCompleted,
    String? progressId,
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);
}
