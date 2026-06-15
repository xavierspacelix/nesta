import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/rent_record.dart';
import 'rent_repository.dart';

class SupabaseRentRepository implements IRentRepository {
  final SupabaseClient _client;

  SupabaseRentRepository(this._client);

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
  Future<List<RentRecord>> getRentHistory() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final records = await _client
          .from('rent_records')
          .select()
          .eq('house_id', houseId)
          .order('year', ascending: false)
          .order('month', ascending: false);

      final result = <RentRecord>[];
      for (final json in records) {
        final rentId = json['id'] as String;

        // Fetch member payments for this rent record
        final paymentsData = await _client
            .from('member_payments')
            .select('member_id, is_paid, proof_photo, profiles(name, nickname)')
            .eq('rent_record_id', rentId);

        final payments = paymentsData.map((p) {
          final profile = p['profiles'] as Map;
          final memberName = (profile['nickname'] as String?) ?? (profile['name'] as String? ?? 'Unknown').split(' ').first;
          return MemberPayment(
            memberName: memberName,
            isPaid: p['is_paid'] as bool? ?? false,
            proofPhoto: p['proof_photo'] as String?,
          );
        }).toList();

        result.add(RentRecord(
          year: json['year'] as int,
          month: json['month'] as int,
          totalRent: json['total_rent'] as int,
          totalWifi: json['total_wifi'] as int,
          payments: payments,
          isPaid: json['is_paid'] as bool? ?? false,
          paidAt: json['paid_at'] != null
              ? DateTime.parse(json['paid_at'] as String)
              : null,
          bankName: json['bank_name'] as String?,
          bankAccountNumber: json['bank_account_number'] as String?,
        ));
      }

      return result;
    } catch (e) {
      Log.e('RentRepo', 'getRentHistory failed', e);
      rethrow;
    }
  }

  @override
  Future<void> markPaid(int year, int month, String memberName) async {
    await _updatePayment(year, month, memberName, null);
  }

  @override
  Future<void> uploadProof(int year, int month, String memberName, String photoUrl) async {
    await _updatePayment(year, month, memberName, photoUrl);
  }

  Future<void> _updatePayment(int year, int month, String memberName, String? photoUrl) async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return;

      final profile = await _client
          .from('profiles')
          .select('id')
          .eq('house_id', houseId)
          .eq('name', memberName)
          .maybeSingle();

      if (profile == null) return;

      final rentRecord = await _client
          .from('rent_records')
          .select('id')
          .eq('house_id', houseId)
          .eq('year', year)
          .eq('month', month)
          .maybeSingle();

      if (rentRecord == null) return;

      final updateData = <String, dynamic>{'is_paid': true};
      if (photoUrl != null) updateData['proof_photo'] = photoUrl;

      await _client
          .from('member_payments')
          .update(updateData)
          .eq('rent_record_id', rentRecord['id'] as String)
          .eq('member_id', profile['id'] as String);
    } catch (e) {
      Log.e('RentRepo', '_updatePayment failed', e);
      rethrow;
    }
  }

  @override
  Future<void> setRentAmounts(int year, int month, int totalRent, int totalWifi) async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return;

      await _client.from('rent_records').upsert({
        'house_id': houseId,
        'year': year,
        'month': month,
        'total_rent': totalRent,
        'total_wifi': totalWifi,
      }, onConflict: 'house_id,year,month');

      final record = await _client
          .from('rent_records')
          .select('id')
          .eq('house_id', houseId)
          .eq('year', year)
          .eq('month', month)
          .single();

      final members = await _client
          .from('profiles')
          .select('id')
          .eq('house_id', houseId);

      for (final member in members) {
        await _client.from('member_payments').upsert({
          'rent_record_id': record['id'],
          'member_id': member['id'],
          'is_paid': false,
        }, onConflict: 'rent_record_id,member_id');
      }
    } catch (e) {
      Log.e('RentRepo', 'setRentAmounts failed', e);
      rethrow;
    }
  }
}
