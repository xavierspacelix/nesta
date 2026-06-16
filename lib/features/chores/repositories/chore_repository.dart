import '../models/chore.dart';

abstract class IChoreRepository {
  Future<Chore?> getTodayChore();
  Future<List<Chore>> getTodayChores();
}

class MockChoreRepository implements IChoreRepository {
  @override
  Future<Chore?> getTodayChore() async {
    await Future.delayed(const Duration(seconds: 1));
    return const Chore(
      id: '1',
      title: 'Kamar Mandi',
      completedTasks: 0,
      totalTasks: 3,
      isStarted: false,
    );
  }

  @override
  Future<List<Chore>> getTodayChores() async {
    await Future.delayed(const Duration(seconds: 1));
    return const [
      Chore(id: '1', title: 'Kamar Mandi', completedTasks: 0, totalTasks: 3, isStarted: false),
      Chore(id: '2', title: 'Dapur', completedTasks: 3, totalTasks: 3, isStarted: true),
      Chore(id: '3', title: 'Ruang Tamu', completedTasks: 0, totalTasks: 2, isStarted: false),
    ];
  }
}
