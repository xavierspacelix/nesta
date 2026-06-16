import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/fine_entry.dart';
import 'fine_repository.dart';

class SupabaseFineRepository implements IFineRepository {
  final SupabaseClient _client;

  SupabaseFineRepository(this._client);

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

  List<FineEntry> _mapFines(List<dynamic> rows) {
    return rows.map((json) {
      final memberName = json['profiles'] is Map
          ? ((json['profiles'] as Map)['nickname'] as String?) ??
                ((json['profiles'] as Map)['name'] as String? ?? 'Unknown')
                    .split(' ')
                    .first
          : 'Unknown';
      final amount = json['amount'] as int;
      final statusStr = json['status'] as String;
      final status = switch (statusStr) {
        'paid' => FineStatus.paid,
        'pending_verification' => FineStatus.pendingVerification,
        _ => FineStatus.unpaid,
      };
      return FineEntry(
        id: json['id'] as String,
        memberId: json['member_id'] as String,
        memberName: memberName,
        reason: json['reason'] as String,
        amount: amount,
        completionPercentage: _calcPercentage(amount),
        date: DateTime.parse(json['created_at'] as String),
        status: status,
        proofPhoto: json['proof_photo'] as String?,
      );
    }).toList();
  }

  double _calcPercentage(int amount) {
    const maxFine = 50000;
    if (amount >= maxFine) return 0.0;
    return (maxFine - amount) / maxFine;
  }

  @override
  Future<List<FineEntry>> getCurrentFines() async {
    try {
      await generateFines();

      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final response = await _client
          .from('fines')
          .select(
            'id, member_id, reason, amount, status, created_at, proof_photo, profiles!fines_member_id_fkey(name, nickname)',
          )
          .eq('house_id', houseId)
          .filter('status', 'in', '(unpaid,pending_verification)')
          .order('created_at', ascending: false);

      return _mapFines(response);
    } catch (e) {
      Log.e('FineRepo', 'getCurrentFines failed', e);
      rethrow;
    }
  }

  @override
  Future<List<FineEntry>> getFineHistory() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final response = await _client
          .from('fines')
          .select(
            'id, member_id, reason, amount, status, created_at, proof_photo, profiles!fines_member_id_fkey(name, nickname)',
          )
          .eq('house_id', houseId)
          .eq('status', 'paid')
          .order('created_at', ascending: false);

      return _mapFines(response);
    } catch (e) {
      Log.e('FineRepo', 'getFineHistory failed', e);
      rethrow;
    }
  }

  @override
  Future<int> getMonthlyTotal() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return 0;

      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 0);

      final response = await _client
          .from('fines')
          .select('amount')
          .eq('house_id', houseId)
          .gte('created_at', monthStart.toIso8601String())
          .lte('created_at', monthEnd.toIso8601String());

      return response.fold<int>(
        0,
        (sum, json) => sum + (json['amount'] as int),
      );
    } catch (e) {
      Log.e('FineRepo', 'getMonthlyTotal failed', e);
      rethrow;
    }
  }

  @override
  Future<FineEntry?> getFineById(String fineId) async {
    try {
      final response = await _client
          .from('fines')
          .select(
            'id, member_id, reason, amount, status, created_at, proof_photo, profiles!fines_member_id_fkey(name, nickname)',
          )
          .eq('id', fineId)
          .maybeSingle();

      if (response == null) return null;
      return _mapFines([response]).first;
    } catch (e) {
      Log.e('FineRepo', 'getFineById failed', e);
      rethrow;
    }
  }

  @override
  Future<void> markAsPaid(String fineId) async {
    try {
      await _client
          .from('fines')
          .update({
            'status': 'paid',
            'paid_at': DateTime.now().toIso8601String(),
          })
          .eq('id', fineId);
    } catch (e) {
      Log.e('FineRepo', 'markAsPaid failed', e);
      rethrow;
    }
  }

  @override
  Future<void> uploadProof(String fineId, String photoUrl) async {
    try {
      final isOwner = await _isOwner();
      await _client
          .from('fines')
          .update({
            'proof_photo': photoUrl,
            'status': isOwner ? 'paid' : 'pending_verification',
            'paid_by': _userId,
            if (isOwner) 'verified_by': _userId,
            if (isOwner) 'verified_at': DateTime.now().toIso8601String(),
          })
          .eq('id', fineId);
    } catch (e) {
      Log.e('FineRepo', 'uploadProof failed', e);
      rethrow;
    }
  }

  @override
  Future<void> verifyPayment(String fineId) async {
    try {
      await _client
          .from('fines')
          .update({
            'status': 'paid',
            'verified_by': _userId,
            'verified_at': DateTime.now().toIso8601String(),
          })
          .eq('id', fineId);
    } catch (e) {
      Log.e('FineRepo', 'verifyPayment failed', e);
      rethrow;
    }
  }

  @override
  Future<void> generateFines() async {
    try {
      await _client.rpc('generate_fines');
    } catch (e) {
      Log.e('FineRepo', 'generateFines failed', e);
    }
  }
}
