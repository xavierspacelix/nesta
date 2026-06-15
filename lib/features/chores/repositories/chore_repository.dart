import '../models/chore.dart';

abstract class IChoreRepository {
  Future<Chore?> getTodayChore();
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
}
