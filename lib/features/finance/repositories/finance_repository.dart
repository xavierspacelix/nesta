import '../models/house_stat.dart';
import '../models/monthly_expenses.dart';

abstract class IFinanceRepository {
  Future<HouseStat> getHouseStats();
  Future<MonthlyExpenses?> getMonthlyExpenses(int year, int month);
  Future<DateTime?> getHouseCreatedAt();
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

  @override
  Future<MonthlyExpenses?> getMonthlyExpenses(int year, int month) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const MonthlyExpenses(
      year: 2026,
      month: 6,
      rent: 3000000,
      wifi: 500000,
      electricity: 350000,
      waterCount: 2,
      fines: 45000,
    );
  }

  @override
  Future<DateTime?> getHouseCreatedAt() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return DateTime.now().subtract(const Duration(days: 180));
  }
}
