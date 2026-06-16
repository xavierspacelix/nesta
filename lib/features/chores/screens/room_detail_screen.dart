import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/chores/providers/room_provider.dart';
import 'package:nesta/features/chores/widgets/add_task_bottom_sheet.dart';

class RoomDetailScreen extends ConsumerWidget {
  final String roomId;

  const RoomDetailScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(roomsProvider);
    final checklistAsync = ref.watch(checklistProvider(roomId));

    final room = roomsAsync.valueOrNull?.where((r) => r.id == roomId).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(room?.name ?? 'Detail Ruangan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskBottomSheet(context, ref, roomId),
        child: const Icon(Icons.add),
      ),
      body: checklistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Gagal memuat tugas')),
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(roomsProvider);
            await ref.read(roomsProvider.future);
            ref.invalidate(checklistProvider(roomId));
            await ref.read(checklistProvider(roomId).future);
          },
          child: items.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.checklist_outlined,
                            size: 64, color: AppTheme.neutral300),
                        const SizedBox(height: 16),
                        Text('Belum ada tugas',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text('Tambahkan tugas untuk ruangan ini',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.neutral500,
                                )),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _ChecklistCard(
                      itemId: item.id,
                      title: item.title,
                      onDelete: () => ref
                          .read(checklistProvider(roomId).notifier)
                          .removeItem(item.id),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  final String itemId;
  final String title;
  final VoidCallback onDelete;

  const _ChecklistCard({
    required this.itemId,
    required this.title,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.neutral200),
      ),
      child: ListTile(
        leading: const Icon(Icons.drag_indicator, color: AppTheme.neutral400),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          color: AppTheme.error,
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Hapus tugas?'),
                content: Text('"$title" akan dihapus dari daftar.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal')),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onDelete();
                    },
                    child: const Text('Hapus',
                        style: TextStyle(color: AppTheme.error)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
