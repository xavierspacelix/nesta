import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_version.dart';

abstract class IVersionRepository {
  Future<AppVersion?> getLatestVersion();
}

class SupabaseVersionRepository implements IVersionRepository {
  final SupabaseClient _client;

  SupabaseVersionRepository(this._client);

  @override
  Future<AppVersion?> getLatestVersion() async {
    try {
      final data = await _client
          .from('app_versions')
          .select()
          .order('build_number', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data == null) return null;
      return AppVersion.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
