import '../models/task_verification.dart';

abstract class ITaskVerificationRepository {
  Future<TaskVerification> getVerification(String taskId);
  Future<void> approveTask(String taskId);
}

class MockTaskVerificationRepository implements ITaskVerificationRepository {
  final Map<String, TaskVerification> _data = {};

  MockTaskVerificationRepository() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();

    _data['task_1'] = TaskVerification(
      id: 'task_1',
      roomName: 'Kamar Utama',
      assignedUser: 'Budi',
      assignedDate: now,
      completedAt: now.add(const Duration(hours: 2)),
      completionPercentage: 0.6,
      completedItems: 3,
      totalItems: 5,
      beforePhoto: 'https://picsum.photos/seed/before1/400/300',
      afterPhoto: 'https://picsum.photos/seed/after1/400/300',
      status: VerificationStatus.late,
    );

    _data['task_3'] = TaskVerification(
      id: 'task_3',
      roomName: 'Kamar Mandi',
      assignedUser: 'Rizki',
      assignedDate: now.subtract(const Duration(days: 1)),
      completedAt: now.subtract(const Duration(days: 1)).add(const Duration(hours: 1)),
      completionPercentage: 1.0,
      completedItems: 4,
      totalItems: 4,
      beforePhoto: 'https://picsum.photos/seed/before2/400/300',
      afterPhoto: 'https://picsum.photos/seed/after2/400/300',
      status: VerificationStatus.completed,
    );

    _data['task_missed'] = TaskVerification(
      id: 'task_missed',
      roomName: 'Teras',
      assignedUser: 'Dika',
      assignedDate: now.subtract(const Duration(days: 2)),
      completedAt: null,
      completionPercentage: 0.0,
      completedItems: 0,
      totalItems: 3,
      status: VerificationStatus.missed,
    );
  }

  @override
  Future<TaskVerification> getVerification(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _data[taskId] ?? _data['task_1']!;
  }

  @override
  Future<void> approveTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final current = _data[taskId];
    if (current != null && current.status != VerificationStatus.completed) {
      _data[taskId] = current.copyWith(
        status: VerificationStatus.completed,
        completedAt: DateTime.now(),
      );
    }
  }
}
