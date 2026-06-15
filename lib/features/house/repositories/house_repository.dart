import 'package:supabase_flutter/supabase_flutter.dart';

class House {
  final String id;
  final String name;
  final String inviteCode;
  final DateTime createdAt;

  const House({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.createdAt,
  });

  factory House.fromMap(Map<String, dynamic> map) {
    return House(
      id: map['id'] as String,
      name: map['name'] as String,
      inviteCode: map['invite_code'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

abstract class IHouseRepository {
  Future<House> createHouse(String name);
  Future<House?> joinHouse(String inviteCode, String userId);
  Future<House?> getHouseByUserId(String userId);
  Future<House?> getHouseById(String houseId);
  Future<void> updateHouse(String houseId, Map<String, dynamic> data);
  Future<void> leaveHouse(String userId);
}
