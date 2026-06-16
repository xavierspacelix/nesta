import 'package:nesta/core/services/logger.dart';
import 'package:nesta/features/settings/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/house_member.dart';
import 'members_repository.dart';

class SupabaseMembersRepository implements IMembersRepository {
  final SupabaseClient _client;

  SupabaseMembersRepository(this._client);

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
  Future<List<HouseMember>> getMembers() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final response = await _client
          .from('profiles')
          .select('id, name, nickname, role, status, avatar_url')
          .eq('house_id', houseId)
          .order('created_at');

      final members = <HouseMember>[];
      for (final json in response) {
        final memberId = json['id'] as String;

        final completedAssignments = await _client
            .from('assignments')
            .select('id')
            .eq('assigned_to', memberId)
            .eq('status', 'completed');

        final fines = await _client
            .from('fines')
            .select('amount')
            .eq('member_id', memberId)
            .eq('status', 'unpaid');

        final totalFines = fines.fold<int>(0, (sum, f) => sum + (f['amount'] as int));

        members.add(HouseMember(
          name: (json['nickname'] as String?) ?? (json['name'] as String? ?? 'Unknown').split(' ').first,
          role: json['role'] as String == 'admin' ? 'Owner' : 'Member',
          tasksCompleted: completedAssignments.length,
          totalFines: totalFines,
          status: json['status'] as String == 'active' ? 'Aktif' : 'Tidak Aktif',
          avatarUrl: json['avatar_url'] as String?,
        ));
      }

      return members;
    } catch (e) {
      Log.e('MembersRepo', 'getMembers failed', e);
      rethrow;
    }
  }

  @override
  Future<UserProfile?> getCurrentProfile() async {
    try {
      final json = await _client
          .from('profiles')
          .select('*')
          .eq('id', _userId)
          .maybeSingle();

      if (json == null) return null;

      final houseId = json['house_id'] as String?;

      int tasksCompleted = 0;
      int totalFines = 0;

      if (houseId != null) {
        final completed = await _client
            .from('assignments')
            .select('id')
            .eq('assigned_to', _userId)
            .eq('status', 'completed');

        tasksCompleted = completed.length;

        final fines = await _client
            .from('fines')
            .select('amount')
            .eq('member_id', _userId)
            .eq('status', 'unpaid');

        totalFines = fines.fold<int>(0, (sum, f) => sum + (f['amount'] as int));
      }

      final createdAt = json['created_at'] != null
          ? (json['created_at'] is DateTime
              ? json['created_at'] as DateTime
              : DateTime.tryParse(json['created_at'] as String))
          : null;

      return UserProfile(
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        avatarUrl: json['avatar_url'] as String?,
        role: (json['role'] as String?) == 'admin' ? 'Owner' : 'Member',
        status: (json['status'] as String?) == 'active' ? 'Aktif' : 'Tidak Aktif',
        roomName: null,
        createdAt: createdAt,
        tasksCompleted: tasksCompleted,
        totalFines: totalFines,
      );
    } catch (e) {
      Log.e('MembersRepo', 'getCurrentProfile failed', e);
      return null;
    }
  }

  @override
  Future<void> updateAvatar(String avatarUrl) async {
    try {
      await _client
          .from('profiles')
          .update({'avatar_url': avatarUrl})
          .eq('id', _userId);
    } catch (e) {
      Log.e('MembersRepo', 'updateAvatar failed', e);
      rethrow;
    }
  }
}
