import '../models/house_stat.dart';

abstract class IFinanceRepository {
  Future<HouseStat> getHouseStats();
}

class MockFinanceRepository implements IFinanceRepository {
  @override
  Future<HouseStat> getHouseStats() async {
    await Future.delayed(const Duration(seconds: 1));
    return const HouseStat(
      completedToday: '2/4',
      activeFines: 'Rp25rb',
      monthlyPerformance: '85%',
      upcomingBills: 'Listrik',
    );
  }
}
