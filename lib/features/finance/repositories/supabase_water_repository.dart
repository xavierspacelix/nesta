import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/water_schedule.dart';
import 'water_repository.dart';

class SupabaseWaterRepository implements IWaterRepository {
  final SupabaseClient _client;

  SupabaseWaterRepository(this._client);

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

  Future<List<String>> _getMemberNames() async {
    final houseId = await _getHouseId();
    if (houseId == null) return [];

    final profiles = await _client
        .from('profiles')
        .select('name')
        .eq('house_id', houseId)
        .order('created_at');

    return profiles.map((p) => p['name'] as String).toList();
  }

  @override
  Future<WaterSchedule> getSchedule() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) {
        return WaterSchedule(
          nextBuyer: '-',
          lastBuyer: '-',
          lastPurchaseDate: null,
          daysSinceLastPurchase: 0,
          history: [],
        );
      }

      final purchases = await _client
          .from('water_purchases')
          .select('buyer_name, purchased_at')
          .eq('house_id', houseId)
          .order('purchased_at', ascending: false);

      final history = purchases.map((p) {
        return WaterPurchase(
          buyerName: p['buyer_name'] as String,
          date: DateTime.parse(p['purchased_at'] as String),
        );
      }).toList();

      final members = await _getMemberNames();

      // Determine next buyer: cycled from last buyer
      String nextBuyer = members.isNotEmpty ? members[0] : '-';
      String lastBuyer = '-';
      DateTime? lastDate;

      if (history.isNotEmpty) {
        lastBuyer = history.first.buyerName;
        lastDate = history.first.date;

        if (members.isNotEmpty) {
          final lastIdx = members.indexOf(lastBuyer);
          if (lastIdx >= 0) {
            nextBuyer = members[(lastIdx + 1) % members.length];
          }
        }
      }

      final daysSince = lastDate != null
          ? DateTime.now().difference(lastDate).inDays
          : 0;

      return WaterSchedule(
        nextBuyer: nextBuyer,
        lastBuyer: lastBuyer,
        lastPurchaseDate: lastDate,
        daysSinceLastPurchase: daysSince,
        history: history,
      );
    } catch (e) {
      Log.e('WaterRepo', 'getSchedule failed', e);
      rethrow;
    }
  }

  @override
  Future<void> markPurchased() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return;

      final schedule = await getSchedule();

      await _client.from('water_purchases').insert({
        'house_id': houseId,
        'buyer_name': schedule.nextBuyer,
      });
    } catch (e) {
      Log.e('WaterRepo', 'markPurchased failed', e);
      rethrow;
    }
  }
}
