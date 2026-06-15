import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/swap_request.dart';
import 'swap_repository.dart';

class SupabaseSwapRepository implements ISwapRepository {
  final SupabaseClient _client;

  SupabaseSwapRepository(this._client);

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

  Future<String> _getUserIdByName(String name) async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return '';

      final profile = await _client
          .from('profiles')
          .select('id')
          .eq('house_id', houseId)
          .eq('name', name)
          .maybeSingle();
      if (profile == null) return '';
      return profile['id'] as String? ?? '';
    } catch (e) {
      Log.e('SwapRepo', '_getUserIdByName failed', e);
      rethrow;
    }
  }

  @override
  Future<List<String>> getMembers() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final response = await _client
          .from('profiles')
          .select('name, nickname')
          .eq('house_id', houseId)
          .neq('id', _userId)
          .order('created_at');

      return response.map((json) => (json['nickname'] as String?) ?? (json['name'] as String? ?? 'Unknown').split(' ').first).toList();
    } catch (e) {
      Log.e('SwapRepo', 'getMembers failed', e);
      rethrow;
    }
  }

  @override
  Future<List<SwapRequest>> getPendingRequests() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final response = await _client
          .from('swap_requests')
          .select('''
            id, schedule_date, reason, status, created_at,
            requester!swap_requests_requester_id_fkey(name, nickname),
            target!swap_requests_target_id_fkey(name, nickname)
          ''')
          .eq('house_id', houseId)
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      return response.map((json) {
        return SwapRequest(
          id: json['id'] as String,
          requesterName: (json['requester'] as Map?)?['nickname'] as String? ?? ((json['requester'] as Map)['name'] as String? ?? 'Unknown').split(' ').first,
          targetMemberName: (json['target'] as Map?)?['nickname'] as String? ?? ((json['target'] as Map)['name'] as String? ?? 'Unknown').split(' ').first,
          scheduleDate: DateTime.parse(json['schedule_date'] as String),
          reason: json['reason'] as String,
          status: SwapStatus.pending,
          createdAt: DateTime.parse(json['created_at'] as String),
        );
      }).toList();
    } catch (e) {
      Log.e('SwapRepo', 'getPendingRequests failed', e);
      rethrow;
    }
  }

  @override
  Future<void> createRequest(String targetMember, DateTime date, String reason) async {
    try {
      final houseId = await _getHouseId();
      final targetId = await _getUserIdByName(targetMember);
      if (houseId == null || targetId.isEmpty) return;

      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Find an assignment for the target member on that date
      final assignment = await _client
          .from('assignments')
          .select('id')
          .eq('house_id', houseId)
          .eq('assigned_to', targetId)
          .eq('assigned_date', dateStr)
          .maybeSingle();

      if (assignment == null) return;

      await _client.from('swap_requests').insert({
        'house_id': houseId,
        'requester_id': _userId,
        'target_id': targetId,
        'assignment_id': assignment['id'] as String,
        'schedule_date': dateStr,
        'reason': reason,
      });
    } catch (e) {
      Log.e('SwapRepo', 'createRequest failed', e);
      rethrow;
    }
  }

  @override
  Future<void> approveRequest(String requestId) async {
    try {
      await _client
          .from('swap_requests')
          .update({'status': 'approved'})
          .eq('id', requestId);
    } catch (e) {
      Log.e('SwapRepo', 'approveRequest failed', e);
      rethrow;
    }
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    try {
      await _client
          .from('swap_requests')
          .update({'status': 'rejected'})
          .eq('id', requestId);
    } catch (e) {
      Log.e('SwapRepo', 'rejectRequest failed', e);
      rethrow;
    }
  }
}
