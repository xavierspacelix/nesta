import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/room.dart';
import '../models/checklist_item.dart';
import 'room_repository.dart';

class SupabaseRoomRepository implements IRoomRepository {
  final SupabaseClient _client;

  SupabaseRoomRepository(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<String> _getHouseId() async {
    final profile = await _client
        .from('profiles')
        .select('house_id')
        .eq('id', _userId)
        .maybeSingle();
    if (profile == null) return '';
    return profile['house_id'] as String? ?? '';
  }

  @override
  Future<List<Room>> getRooms() async {
    try {
      final houseId = await _getHouseId();
      if (houseId.isEmpty) return [];

      final response = await _client
          .from('rooms')
          .select('id, name, house_id')
          .eq('house_id', houseId)
          .order('created_at');

      final rooms = response.map((json) {
        return Room(
          id: json['id'] as String,
          name: json['name'] as String,
          houseId: json['house_id'] as String,
          itemCount: 0,
        );
      }).toList();

      for (final room in rooms) {
        final items = await _client
            .from('checklist_items')
            .select('id')
            .eq('room_id', room.id);
        final index = rooms.indexWhere((r) => r.id == room.id);
        rooms[index] = room.copyWith(itemCount: items.length);
      }
      return rooms;
    } catch (e) {
      Log.e('RoomRepo', 'getRooms failed', e);
      rethrow;
    }
  }

  @override
  Future<Room> createRoom(String name) async {
    try {
      final profile = await _client
          .from('profiles')
          .select('house_id')
          .eq('id', _client.auth.currentUser!.id)
          .single();

      final response = await _client
          .from('rooms')
          .insert({'name': name, 'house_id': profile['house_id'] as String})
          .select()
          .single();

      return Room(
        id: response['id'] as String,
        name: response['name'] as String,
        houseId: response['house_id'] as String,
        itemCount: 0,
      );
    } catch (e) {
      Log.e('RoomRepo', 'createRoom failed', e);
      rethrow;
    }
  }

  @override
  Future<Room> updateRoom(String id, String name) async {
    try {
      final response = await _client
          .from('rooms')
          .update({'name': name})
          .eq('id', id)
          .select()
          .single();

      return Room(
        id: response['id'] as String,
        name: response['name'] as String,
        houseId: response['house_id'] as String,
        itemCount: 0,
      );
    } catch (e) {
      Log.e('RoomRepo', 'updateRoom failed', e);
      rethrow;
    }
  }

  @override
  Future<void> deleteRoom(String id) async {
    try {
      await _client.from('rooms').delete().eq('id', id);
    } catch (e) {
      Log.e('RoomRepo', 'deleteRoom failed', e);
      rethrow;
    }
  }

  @override
  Future<List<ChecklistItem>> getChecklist(String roomId) async {
    try {
      final response = await _client
          .from('checklist_items')
          .select('id, title, room_id')
          .eq('room_id', roomId)
          .order('created_at');

      return response.map((json) {
        return ChecklistItem(
          id: json['id'] as String,
          title: json['title'] as String,
          roomId: json['room_id'] as String,
        );
      }).toList();
    } catch (e) {
      Log.e('RoomRepo', 'getChecklist failed', e);
      rethrow;
    }
  }

  @override
  Future<ChecklistItem> addChecklistItem(String roomId, String title) async {
    try {
      final response = await _client
          .from('checklist_items')
          .insert({'room_id': roomId, 'title': title})
          .select()
          .single();

      return ChecklistItem(
        id: response['id'] as String,
        title: response['title'] as String,
        roomId: response['room_id'] as String,
      );
    } catch (e) {
      Log.e('RoomRepo', 'addChecklistItem failed', e);
      rethrow;
    }
  }

  @override
  Future<void> removeChecklistItem(String itemId) async {
    try {
      await _client.from('checklist_items').delete().eq('id', itemId);
    } catch (e) {
      Log.e('RoomRepo', 'removeChecklistItem failed', e);
      rethrow;
    }
  }
}
