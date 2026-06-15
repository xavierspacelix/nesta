import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'house_repository.dart';

class SupabaseHouseRepository implements IHouseRepository {
  final SupabaseClient _client;

  SupabaseHouseRepository(this._client);

  @override
  Future<House> createHouse(String name) async {
    Log.i('HouseRepo', 'createHouse: $name');
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Belum login. Silakan login terlebih dahulu.');

    final response = await _client.rpc('create_house', params: {
      'house_name': name,
    });

    final house = House.fromMap(response as Map<String, dynamic>);
    Log.i('HouseRepo', 'created: ${house.id} code=${house.inviteCode}');
    return house;
  }

  @override
  Future<House?> joinHouse(String inviteCode, String userId) async {
    Log.i('HouseRepo', 'joinHouse: code=$inviteCode userId=$userId');
    final response = await _client.rpc('get_house_by_invite', params: {
      'code': inviteCode,
    });

    if (response == null) {
      Log.w('HouseRepo', 'no house found for code=$inviteCode');
      return null;
    }

    final house = House.fromMap(response as Map<String, dynamic>);
    Log.d('HouseRepo', 'found house: ${house.id}');

    await _client
        .from('profiles')
        .update({'house_id': house.id, 'role': 'member'})
        .eq('id', userId);

    Log.i('HouseRepo', 'joined house: ${house.name}');
    return house;
  }

  @override
  Future<House?> getHouseByUserId(String userId) async {
    Log.d('HouseRepo', 'getHouseByUserId: $userId');
    final profile = await _client
        .from('profiles')
        .select('house_id')
        .eq('id', userId)
        .maybeSingle();

    if (profile == null || profile['house_id'] == null) {
      Log.d('HouseRepo', 'no house for user');
      return null;
    }

    return getHouseById(profile['house_id'] as String);
  }

  @override
  Future<House?> getHouseById(String houseId) async {
    Log.d('HouseRepo', 'getHouseById: $houseId');
    final response = await _client
        .from('houses')
        .select()
        .eq('id', houseId)
        .maybeSingle();

    if (response == null) {
      Log.w('HouseRepo', 'house not found: $houseId');
      return null;
    }
    return House.fromMap(response);
  }

  @override
  Future<void> updateHouse(String houseId, Map<String, dynamic> data) async {
    Log.d('HouseRepo', 'updateHouse: $houseId $data');
    await _client.from('houses').update(data).eq('id', houseId);
  }

  @override
  Future<void> leaveHouse(String userId) async {
    Log.i('HouseRepo', 'leaveHouse: $userId');
    await _client
        .from('profiles')
        .update({'house_id': null, 'role': 'member'})
        .eq('id', userId);
  }
}
