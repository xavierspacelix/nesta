import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/house_stat.dart';
import '../models/monthly_expenses.dart';
import '../repositories/finance_repository.dart';
import '../repositories/supabase_finance_repository.dart';

final financeRepositoryProvider = Provider<IFinanceRepository>((ref) {
  return SupabaseFinanceRepository(Supabase.instance.client);
});

final houseStatsProvider = AsyncNotifierProvider<HouseStatsNotifier, HouseStat>(() {
  return HouseStatsNotifier();
});

class HouseStatsNotifier extends AsyncNotifier<HouseStat> {
  @override
  Future<HouseStat> build() async {
    final repository = ref.watch(financeRepositoryProvider);
    return repository.getHouseStats();
  }
}

final selectedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

final houseCreatedAtProvider = FutureProvider<DateTime?>((ref) {
  final repository = ref.watch(financeRepositoryProvider);
  return repository.getHouseCreatedAt();
});

final monthlyExpensesProvider = FutureProvider.family<MonthlyExpenses?, DateTime>((ref, date) {
  final repository = ref.watch(financeRepositoryProvider);
  return repository.getMonthlyExpenses(date.year, date.month);
});
