import 'package:collection/collection.dart';
import '../models/room.dart';
import '../models/checklist_item.dart';

abstract class IRoomRepository {
  Future<List<Room>> getRooms();
  Future<Room> createRoom(String name);
  Future<Room> updateRoom(String id, String name);
  Future<void> deleteRoom(String id);
  Future<List<ChecklistItem>> getChecklist(String roomId);
  Future<ChecklistItem> addChecklistItem(String roomId, String title);
  Future<void> removeChecklistItem(String itemId);
}

class MockRoomRepository implements IRoomRepository {
  final List<Room> _rooms = [];
  final List<ChecklistItem> _items = [];
  int _roomIdCounter = 1;
  int _itemIdCounter = 1;

  MockRoomRepository() {
    _seedData();
  }

  void _seedData() {
    _rooms.addAll([
      const Room(id: '1', name: 'Kamar Utama', houseId: 'house1', itemCount: 4),
      const Room(id: '2', name: 'Dapur', houseId: 'house1', itemCount: 3),
      const Room(id: '3', name: 'Kamar Mandi', houseId: 'house1', itemCount: 3),
    ]);
    _roomIdCounter = 4;

    _items.addAll([
      const ChecklistItem(id: '1', title: 'Sapu Lantai', roomId: '1'),
      const ChecklistItem(id: '2', title: 'Pel Lantai', roomId: '1'),
      const ChecklistItem(id: '3', title: 'Rapihkan Tempat Tidur', roomId: '1'),
      const ChecklistItem(id: '4', title: 'Bersihkan Debu', roomId: '1'),
      const ChecklistItem(id: '5', title: 'Sapu Lantai', roomId: '2'),
      const ChecklistItem(id: '6', title: 'Pel Lantai', roomId: '2'),
      const ChecklistItem(id: '7', title: 'Cuci Wastafel', roomId: '2'),
      const ChecklistItem(id: '8', title: 'Sapu Lantai', roomId: '3'),
      const ChecklistItem(id: '9', title: 'Bersihkan Toilet', roomId: '3'),
      const ChecklistItem(id: '10', title: 'Cuci Wastafel', roomId: '3'),
    ]);
    _itemIdCounter = 11;
  }

  @override
  Future<List<Room>> getRooms() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_rooms);
  }

  @override
  Future<Room> createRoom(String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final room = Room(
      id: '${_roomIdCounter++}',
      name: name,
      houseId: 'house1',
      itemCount: 0,
    );
    _rooms.add(room);
    return room;
  }

  @override
  Future<Room> updateRoom(String id, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _rooms.indexWhere((r) => r.id == id);
    if (index == -1) throw Exception('Room not found');
    final updated = _rooms[index].copyWith(name: name);
    _rooms[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteRoom(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _rooms.removeWhere((r) => r.id == id);
    _items.removeWhere((i) => i.roomId == id);
  }

  @override
  Future<List<ChecklistItem>> getChecklist(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _items.where((i) => i.roomId == roomId).toList();
  }

  @override
  Future<ChecklistItem> addChecklistItem(String roomId, String title) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final item = ChecklistItem(
      id: '${_itemIdCounter++}',
      title: title,
      roomId: roomId,
    );
    _items.add(item);
    final roomIndex = _rooms.indexWhere((r) => r.id == roomId);
    if (roomIndex != -1) {
      final room = _rooms[roomIndex];
      _rooms[roomIndex] = room.copyWith(itemCount: room.itemCount + 1);
    }
    return item;
  }

  @override
  Future<void> removeChecklistItem(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final item = _items.firstWhereOrNull((i) => i.id == itemId);
    _items.removeWhere((i) => i.id == itemId);
    if (item != null) {
      final roomIndex = _rooms.indexWhere((r) => r.id == item.roomId);
      if (roomIndex != -1) {
        final room = _rooms[roomIndex];
        _rooms[roomIndex] = room.copyWith(itemCount: room.itemCount - 1);
      }
    }
  }
}
