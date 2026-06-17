import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IDeviceTokenRepository {
  Future<void> upsert(String token, String platform);
  Future<void> delete(String token);
}

class SupabaseDeviceTokenRepository implements IDeviceTokenRepository {
  final SupabaseClient _client;

  SupabaseDeviceTokenRepository(this._client);

  @override
  Future<void> upsert(String token, String platform) async {
    await _client.rpc('upsert_device_token', params: {
      'p_token': token,
      'p_platform': platform,
    });
  }

  @override
  Future<void> delete(String token) async {
    await _client.from('device_tokens').delete().eq('token', token);
  }
}
