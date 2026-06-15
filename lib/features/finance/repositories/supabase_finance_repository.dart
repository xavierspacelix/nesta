import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/house_stat.dart';
import 'finance_repository.dart';

class SupabaseFinanceRepository implements IFinanceRepository {
  final SupabaseClient _client;

  SupabaseFinanceRepository(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<String?> _getHouseId() async {
    final profile = await _client
        .from('profiles')
        .select('house_id')
        .eq('id', _userId)
        .maybeSingle();
    if (profile == null) return null;
    return profile['house_id'] as String?;
  }

  @override
  Future<HouseStat> getHouseStats() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) {
        return const HouseStat(
          completedToday: '0/0',
          activeFines: 'Rp0',
          monthlyPerformance: '0%',
          upcomingBills: '-',
        );
      }

      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      // Count today's assignments by status
      final todayAssignments = await _client
          .from('assignments')
          .select('status')
          .eq('house_id', houseId)
          .eq('assigned_date', todayStr);

      final totalToday = todayAssignments.length;
      final completedToday = todayAssignments
          .where((a) => a['status'] == 'completed')
          .length;

      // Sum unpaid fines
      final fines = await _client
          .from('fines')
          .select('amount')
          .eq('house_id', houseId)
          .eq('status', 'unpaid');

      final totalFines = fines.fold<int>(0, (sum, f) => sum + (f['amount'] as int));
      final fineStr = 'Rp${_formatAmount(totalFines)}';

      // Calculate monthly completion rate
      final monthStart = DateTime(today.year, today.month, 1);
      final monthEnd = DateTime(today.year, today.month + 1, 0);

      final monthAssignments = await _client
          .from('assignments')
          .select('status')
          .eq('house_id', houseId)
          .gte('assigned_date', monthStart.toIso8601String().substring(0, 10))
          .lte('assigned_date', monthEnd.toIso8601String().substring(0, 10));

      final totalMonth = monthAssignments.length;
      final completedMonth = monthAssignments
          .where((a) => a['status'] == 'completed')
          .length;
      final perf = totalMonth > 0 ? (completedMonth / totalMonth * 100).round() : 0;

      // Determine upcoming bill
      String upcomingBills = '-';
      final latestRent = await _client
          .from('rent_records')
          .select('is_paid')
          .eq('house_id', houseId)
          .order('year', ascending: false)
          .order('month', ascending: false)
          .limit(1)
          .maybeSingle();
      if (latestRent != null && latestRent['is_paid'] == false) {
        upcomingBills = 'Sewa';
      } else {
        upcomingBills = 'Listrik';
      }

      return HouseStat(
        completedToday: '$completedToday/$totalToday',
        activeFines: fineStr,
        monthlyPerformance: '$perf%',
        upcomingBills: upcomingBills,
      );
    } catch (e) {
      Log.e('FinanceRepo', 'getHouseStats failed', e);
      rethrow;
    }
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    final result = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) result.write('.');
      result.write(str[i]);
    }
    return result.toString();
  }
}
