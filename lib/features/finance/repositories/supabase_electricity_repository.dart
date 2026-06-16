import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/electricity_purchase.dart';
import 'electricity_repository.dart';

class SupabaseElectricityRepository implements IElectricityRepository {
  final SupabaseClient _client;

  SupabaseElectricityRepository(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<bool> _isOwner() async {
    final profile = await _client
        .from('profiles')
        .select('role')
        .eq('id', _userId)
        .maybeSingle();
    return profile?['role'] == 'admin';
  }

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
          .select('id, amount, proof_photo, is_verified, purchased_at, profiles!electricity_purchases_purchased_by_fkey(name, nickname)')
          .eq('house_id', houseId)
          .order('purchased_at', ascending: false);

      return response.map((json) {
        final profile = json['profiles'] as Map?;
        final userName = profile != null
            ? ((profile['nickname'] as String?) ?? (profile['name'] as String? ?? 'Unknown').split(' ').first)
            : 'Unknown';
        return ElectricityPurchase(
          id: json['id'] as String,
          amount: json['amount'] as int,
          purchasedBy: userName,
          date: DateTime.parse(json['purchased_at'] as String),
          proofPhoto: json['proof_photo'] as String?,
          isVerified: json['is_verified'] as bool? ?? false,
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

      final isOwner = await _isOwner();

      await _client.from('electricity_purchases').insert({
        'house_id': houseId,
        'amount': amount,
        'purchased_by': memberId,
        if (proofPhoto != null) 'proof_photo': proofPhoto,
        if (isOwner) 'is_verified': true,
        if (isOwner) 'verified_by': _userId,
        if (isOwner) 'verified_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      Log.e('ElectricityRepo', 'addPurchase failed', e);
      rethrow;
    }
  }

  @override
  Future<void> verifyPurchase(String purchaseId) async {
    try {
      final purchase = await _client
          .from('electricity_purchases')
          .select('purchased_by, house_id')
          .eq('id', purchaseId)
          .single();

      await _client
          .from('electricity_purchases')
          .update({
            'is_verified': true,
            'verified_by': _userId,
            'verified_at': DateTime.now().toIso8601String(),
          })
          .eq('id', purchaseId);

      final houseId = purchase['house_id'] as String;
      final buyerId = purchase['purchased_by'] as String;

      await _client.from('activity_feed').insert({
        'house_id': houseId,
        'user_id': _userId,
        'target_user_id': buyerId,
        'description': 'memverifikasi pembelian listrik kamu',
        'category': 'fine',
      });
    } catch (e) {
      Log.e('ElectricityRepo', 'verifyPurchase failed', e);
      rethrow;
    }
  }
}
