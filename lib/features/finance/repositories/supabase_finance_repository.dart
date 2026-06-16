import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/house_stat.dart';
import '../models/monthly_expenses.dart';
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

      final todayAssignments = await _client
          .from('assignments')
          .select('status')
          .eq('house_id', houseId)
          .eq('assigned_date', todayStr);

      final totalToday = todayAssignments.length;
      final completedToday = todayAssignments
          .where((a) => a['status'] == 'completed')
          .length;

      final fines = await _client
          .from('fines')
          .select('amount')
          .eq('house_id', houseId)
          .eq('status', 'unpaid');

      final totalFines = fines.fold<int>(0, (sum, f) => sum + (f['amount'] as int));
      final fineStr = 'Rp${_formatAmount(totalFines)}';

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

      String upcomingBills = '-';
      final now = DateTime.now();
      final currentMonthRent = await _client
          .from('rent_records')
          .select('id, total_rent, total_wifi, due_date')
          .eq('house_id', houseId)
          .eq('year', now.year)
          .eq('month', now.month)
          .maybeSingle();
      if (currentMonthRent != null) {
        final totalRent = currentMonthRent['total_rent'] as int;
        final totalWifi = currentMonthRent['total_wifi'] as int;
        final rentLabel = 'Rp${_formatAmount(totalRent + totalWifi)}';

        final unpaidMembers = await _client
            .from('member_payments')
            .select('id')
            .eq('rent_record_id', currentMonthRent['id'] as String)
            .eq('is_paid', false);

        if (unpaidMembers.isNotEmpty) {
          final dueDate = currentMonthRent['due_date'] as int?;
          upcomingBills = dueDate != null ? '$rentLabel|$dueDate' : rentLabel;
        } else {
          upcomingBills = 'Lunas';
        }
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

  @override
  Future<MonthlyExpenses?> getMonthlyExpenses(int year, int month) async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return null;

      int rent = 0;
      int wifi = 0;

      final rentRecord = await _client
          .from('rent_records')
          .select('total_rent, total_wifi')
          .eq('house_id', houseId)
          .eq('year', year)
          .eq('month', month)
          .maybeSingle();
      if (rentRecord != null) {
        rent = rentRecord['total_rent'] as int;
        wifi = rentRecord['total_wifi'] as int;
      }

      final monthStart = DateTime(year, month, 1);
      final monthEnd = DateTime(year, month + 1, 0);

      final electricityData = await _client
          .from('electricity_purchases')
          .select('amount')
          .eq('house_id', houseId)
          .gte('purchased_at', monthStart.toIso8601String())
          .lte('purchased_at', monthEnd.toIso8601String());
      final electricity =
          electricityData.fold<int>(0, (sum, e) => sum + (e['amount'] as int));

      final waterData = await _client
          .from('water_purchases')
          .select('id')
          .eq('house_id', houseId)
          .gte('purchased_at', monthStart.toIso8601String())
          .lte('purchased_at', monthEnd.toIso8601String());
      final waterCount = waterData.length;

      final finesData = await _client
          .from('fines')
          .select('amount')
          .eq('house_id', houseId)
          .gte('created_at', monthStart.toIso8601String())
          .lte('created_at', monthEnd.toIso8601String());
      final fines =
          finesData.fold<int>(0, (sum, f) => sum + (f['amount'] as int));

      return MonthlyExpenses(
        year: year,
        month: month,
        rent: rent,
        wifi: wifi,
        electricity: electricity,
        waterCount: waterCount,
        fines: fines,
      );
    } catch (e) {
      Log.e('FinanceRepo', 'getMonthlyExpenses failed', e);
      return null;
    }
  }

  @override
  Future<DateTime?> getHouseCreatedAt() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return null;

      final house = await _client
          .from('houses')
          .select('created_at')
          .eq('id', houseId)
          .maybeSingle();

      if (house == null || house['created_at'] == null) return null;
      return DateTime.parse(house['created_at'] as String);
    } catch (e) {
      Log.e('FinanceRepo', 'getHouseCreatedAt failed', e);
      return null;
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
