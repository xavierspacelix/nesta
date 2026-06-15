import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/room.dart';
import '../models/checklist_item.dart';
import '../repositories/room_repository.dart';
import '../repositories/supabase_room_repository.dart';

final roomRepositoryProvider = Provider<IRoomRepository>((ref) {
  return SupabaseRoomRepository(Supabase.instance.client);
});

final roomsProvider = AsyncNotifierProvider<RoomNotifier, List<Room>>(() {
  return RoomNotifier();
});

class RoomNotifier extends AsyncNotifier<List<Room>> {
  @override
  Future<List<Room>> build() async {
    final repository = ref.watch(roomRepositoryProvider);
    return repository.getRooms();
  }

  Future<void> createRoom(String name) async {
    final repository = ref.read(roomRepositoryProvider);
    await repository.createRoom(name);
    ref.invalidateSelf();
  }

  Future<void> updateRoom(String id, String name) async {
    final repository = ref.read(roomRepositoryProvider);
    await repository.updateRoom(id, name);
    ref.invalidateSelf();
  }

  Future<void> deleteRoom(String id) async {
    final repository = ref.read(roomRepositoryProvider);
    await repository.deleteRoom(id);
    ref.invalidateSelf();
  }
}

final checklistProvider = AsyncNotifierProvider.family<ChecklistNotifier, List<ChecklistItem>, String>(
  () => ChecklistNotifier(),
);

class ChecklistNotifier extends FamilyAsyncNotifier<List<ChecklistItem>, String> {
  @override
  Future<List<ChecklistItem>> build(String arg) async {
    final repository = ref.watch(roomRepositoryProvider);
    return repository.getChecklist(arg);
  }

  Future<void> addItem(String title) async {
    final repository = ref.read(roomRepositoryProvider);
    await repository.addChecklistItem(arg, title);
    ref.invalidateSelf();
  }

  Future<void> removeItem(String itemId) async {
    final repository = ref.read(roomRepositoryProvider);
    await repository.removeChecklistItem(itemId);
    ref.invalidateSelf();
  }
}
