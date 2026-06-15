import 'package:freezed_annotation/freezed_annotation.dart';

part 'chore.freezed.dart';
part 'chore.g.dart';

@freezed
abstract class Chore with _$Chore {
  const factory Chore({
    required String id,
    required String title,
    required int completedTasks,
    required int totalTasks,
    required bool isStarted,
  }) = _Chore;

  factory Chore.fromJson(Map<String, dynamic> json) => _$ChoreFromJson(json);
}
