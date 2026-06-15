import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/electricity_purchase.dart';
import 'electricity_repository.dart';

class SupabaseElectricityRepository implements IElectricityRepository {
  final SupabaseClient _client;

  SupabaseElectricityRepository(this._client);

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
  Future<List<ElectricityPurchase>> getPurchases() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final response = await _client
          .from('electricity_purchases')
          .select('id, amount, proof_photo, purchased_at, profiles(name, nickname)')
          .eq('house_id', houseId)
          .order('purchased_at', ascending: false);

      return response.map((json) {
        final profile = json['profiles'] as Map;
        final userName = (profile['nickname'] as String?) ?? (profile['name'] as String? ?? 'Unknown').split(' ').first;
        return ElectricityPurchase(
          id: json['id'] as String,
          amount: json['amount'] as int,
          purchasedBy: userName,
          date: DateTime.parse(json['purchased_at'] as String),
          proofPhoto: json['proof_photo'] as String?,
        );
      }).toList();
    } catch (e) {
      Log.e('ElectricityRepo', 'getPurchases failed', e);
      rethrow;
    }
  }

  @override
  Future<void> addPurchase(int amount, String purchasedBy, String? proofPhoto) async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return;

      // Find user ID by name
      String? memberId = _userId;
      if (purchasedBy.isNotEmpty) {
        final profile = await _client
            .from('profiles')
            .select('id')
            .eq('house_id', houseId)
            .eq('name', purchasedBy)
            .maybeSingle();
        if (profile != null) {
          memberId = profile['id'] as String;
        }
      }

      await _client.from('electricity_purchases').insert({
        'house_id': houseId,
        'amount': amount,
        'purchased_by': memberId,
        if (proofPhoto != null) 'proof_photo': proofPhoto,
      });
    } catch (e) {
      Log.e('ElectricityRepo', 'addPurchase failed', e);
      rethrow;
    }
  }
}
