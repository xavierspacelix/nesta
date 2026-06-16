import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/rent_record.dart';
import 'rent_repository.dart';

class _MemberInfo {
  final String id;
  final String displayName;
  _MemberInfo(this.id, this.displayName);
}

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

      // Always fetch house members for display name resolution
      final allMembers = await _client
          .from('profiles')
          .select('id, name, nickname')
          .eq('house_id', houseId);

      final memberLookup = <String, _MemberInfo>{};
      for (final m in allMembers) {
        final displayName = (m['nickname'] as String?)
            ?? (m['name'] as String? ?? 'Unknown').split(' ').first;
        memberLookup[m['id'] as String] = _MemberInfo(m['id'] as String, displayName);
      }

      final records = await _client
          .from('rent_records')
          .select()
          .eq('house_id', houseId)
          .order('year', ascending: false)
          .order('month', ascending: false);

      final result = <RentRecord>[];
      for (final json in records) {
        final rentId = json['id'] as String;

        final paymentsData = await _client
            .from('member_payments')
            .select('member_id, is_paid, proof_photo, profiles!member_payments_member_id_fkey(name, nickname)')
            .eq('rent_record_id', rentId);

        List<MemberPayment> payments;
        if (paymentsData.isNotEmpty) {
          payments = paymentsData.map((p) {
            final memberId = p['member_id'] as String;
            final profile = p['profiles'] as Map?;
            final memberName = profile != null
                ? ((profile['nickname'] as String?)
                    ?? (profile['name'] as String? ?? 'Unknown').split(' ').first)
                : (memberLookup[memberId]?.displayName ?? 'Unknown');
            return MemberPayment(
              memberId: memberId,
              memberName: memberName,
              isPaid: p['is_paid'] as bool? ?? false,
              proofPhoto: p['proof_photo'] as String?,
            );
          }).toList();
        } else {
          payments = memberLookup.values.map((m) => MemberPayment(
            memberId: m.id,
            memberName: m.displayName,
            isPaid: false,
          )).toList();
        }

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
          dueDate: json['due_date'] as int?,
        ));
      }

      return result;
    } catch (e) {
      Log.e('RentRepo', 'getRentHistory failed', e);
      rethrow;
    }
  }

  @override
  Future<void> _updatePayment(int year, int month, String memberId, String? photoUrl) async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return;

      final rentRecord = await _client
          .from('rent_records')
          .select('id')
          .eq('house_id', houseId)
          .eq('year', year)
          .eq('month', month)
          .maybeSingle();

      if (rentRecord == null) return;

      final updateData = <String, dynamic>{};
      if (photoUrl != null) {
        updateData['proof_photo'] = photoUrl;
      } else {
        updateData['is_paid'] = true;
      }

      updateData['rent_record_id'] = rentRecord['id'] as String;
      updateData['member_id'] = memberId;

      await _client
          .from('member_payments')
          .upsert(updateData, onConflict: 'rent_record_id, member_id');
    } catch (e) {
      Log.e('RentRepo', '_updatePayment failed', e);
      rethrow;
    }
  }

  @override
  Future<void> markPaid(int year, int month, String memberId) async {
    await _updatePayment(year, month, memberId, null);
  }

  @override
  Future<void> uploadProof(int year, int month, String memberId, String photoUrl) async {
    await _updatePayment(year, month, memberId, photoUrl);
  }

  @override
  Future<void> verifyPayment(int year, int month, String memberId) async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return;

      final rentRecord = await _client
          .from('rent_records')
          .select('id, total_rent, total_wifi, due_date, bank_name, bank_account_number')
          .eq('house_id', houseId)
          .eq('year', year)
          .eq('month', month)
          .maybeSingle();

      if (rentRecord == null) return;

      await _client
          .from('member_payments')
          .upsert({
            'rent_record_id': rentRecord['id'] as String,
            'member_id': memberId,
            'is_paid': true,
            'verified_by': _userId,
            'verified_at': DateTime.now().toIso8601String(),
          }, onConflict: 'rent_record_id, member_id');

      // Auto-generate next month when all members are paid
      final unpaid = await _client
          .from('member_payments')
          .select('id')
          .eq('rent_record_id', rentRecord['id'] as String)
          .eq('is_paid', false);

      if (unpaid.isNotEmpty) return;

      final next = DateTime(year, month + 1);
      final nextYear = next.year;
      final nextMonth = next.month;

      final existing = await _client
          .from('rent_records')
          .select('id')
          .eq('house_id', houseId)
          .eq('year', nextYear)
          .eq('month', nextMonth)
          .maybeSingle();

      if (existing != null) return;

      await setRentAmounts(
        nextYear, nextMonth,
        rentRecord['total_rent'] as int,
        rentRecord['total_wifi'] as int,
        bankName: rentRecord['bank_name'] as String?,
        bankAccountNumber: rentRecord['bank_account_number'] as String?,
        dueDate: rentRecord['due_date'] as int?,
      );
    } catch (e) {
      Log.e('RentRepo', 'verifyPayment failed', e);
      rethrow;
    }
  }

  @override
  Future<void> setRentAmounts(int year, int month, int totalRent, int totalWifi, {String? bankName, String? bankAccountNumber, int? dueDate}) async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return;

      await _client.from('rent_records').upsert({
        'house_id': houseId,
        'year': year,
        'month': month,
        'total_rent': totalRent,
        'total_wifi': totalWifi,
        if (bankName != null) 'bank_name': bankName,
        if (bankAccountNumber != null) 'bank_account_number': bankAccountNumber,
        if (dueDate != null) 'due_date': dueDate,
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

      final existingPayments = await _client
          .from('member_payments')
          .select('member_id')
          .eq('rent_record_id', record['id'] as String);

      final existingMemberIds = existingPayments.map((p) => p['member_id'] as String).toSet();

      for (final member in members) {
        final memberId = member['id'] as String;
        if (existingMemberIds.contains(memberId)) continue;
        await _client.from('member_payments').insert({
          'rent_record_id': record['id'],
          'member_id': memberId,
          'is_paid': false,
        });
      }
    } catch (e) {
      Log.e('RentRepo', 'setRentAmounts failed', e);
      rethrow;
    }
  }
}
