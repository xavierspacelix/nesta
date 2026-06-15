import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/chores/providers/room_provider.dart';
import 'package:nesta/features/chores/widgets/add_room_dialog.dart';
import 'package:nesta/features/chores/models/room.dart';

class RoomListScreen extends ConsumerWidget {
  const RoomListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(roomsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Ruangan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddRoomDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: roomsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat ruangan')),
        data: (rooms) {
          if (rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.meeting_room_outlined,
                      size: 64, color: AppTheme.neutral300),
                  const SizedBox(height: 16),
                  Text('Belum ada ruangan',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Tambahkan ruangan pertama kamu',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.neutral500,
                          )),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rooms.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final room = rooms[index];
              return _RoomCard(room: room, ref: ref);
            },
          );
        },
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;
  final WidgetRef ref;

  const _RoomCard({required this.room, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppTheme.neutral200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push('/rooms/${room.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.meeting_room_outlined,
                    color: AppTheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.name,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                )),
                    const SizedBox(height: 2),
                    Text('${room.itemCount} tugas',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.neutral500,
                            )),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: AppTheme.neutral400,
                onPressed: () =>
                    showEditRoomDialog(context, ref, room.id, room.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
