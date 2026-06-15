import '../models/task_detail.dart';
import '../models/checklist_progress.dart';

abstract class ITaskDetailRepository {
  Future<TaskDetail> getTaskDetail(String taskId);
  Future<void> updateChecklistProgress({
    required String assignmentId,
    required String checklistItemId,
    required bool isCompleted,
    required String userId,
  });
}

class MockTaskDetailRepository implements ITaskDetailRepository {
  final Map<String, TaskDetail> _tasks = {};

  MockTaskDetailRepository() {
    _seedData();
  }

  void _seedData() {
    _tasks['task_1'] = TaskDetail(
      id: 'task_1',
      roomName: 'Kamar Utama',
      assignedUser: 'Budi',
      date: DateTime.now(),
      status: TaskStatus.inProgress,
      checklist: [
        ChecklistItem(id: 'c1', name: 'Sapu lantai'),
        ChecklistItem(id: 'c2', name: 'Pel lantai', isCompleted: true),
        ChecklistItem(id: 'c3', name: 'Rapihkan tempat tidur', isCompleted: true),
        ChecklistItem(id: 'c4', name: 'Bersihkan debu'),
        ChecklistItem(id: 'c5', name: 'Atur meja belajar'),
      ],
    );

    _tasks['task_2'] = TaskDetail(
      id: 'task_2',
      roomName: 'Dapur',
      assignedUser: 'Juan',
      date: DateTime.now(),
      status: TaskStatus.pending,
      checklist: [
        ChecklistItem(id: 'c6', name: 'Cuci piring'),
        ChecklistItem(id: 'c7', name: 'Lap meja dapur'),
        ChecklistItem(id: 'c8', name: 'Buang sampah'),
        ChecklistItem(id: 'c9', name: 'Rapihkan peralatan masak'),
      ],
    );

    _tasks['task_3'] = TaskDetail(
      id: 'task_3',
      roomName: 'Kamar Mandi',
      assignedUser: 'Rizki',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: TaskStatus.completed,
      checklist: [
        ChecklistItem(id: 'c10', name: 'Sikat kloset', isCompleted: true),
        ChecklistItem(id: 'c11', name: 'Lap cermin', isCompleted: true),
        ChecklistItem(id: 'c12', name: 'Bersihkan lantai', isCompleted: true),
        ChecklistItem(id: 'c13', name: 'Isi sabun', isCompleted: true),
      ],
    );
  }

  @override
  Future<TaskDetail> getTaskDetail(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tasks[taskId] ?? _tasks['task_1']!;
  }

  @override
  Future<void> updateChecklistProgress({
    required String assignmentId,
    required String checklistItemId,
    required bool isCompleted,
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
