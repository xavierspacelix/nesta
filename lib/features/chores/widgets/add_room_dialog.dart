import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/chores/providers/room_provider.dart';

Future<void> showAddRoomDialog(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Tambah Ruangan'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Nama ruangan',
          filled: true,
          fillColor: AppTheme.neutral50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              Navigator.pop(ctx);
              ref.read(roomsProvider.notifier).createRoom(name);
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}

Future<void> showEditRoomDialog(
    BuildContext context, WidgetRef ref, String roomId, String currentName) {
  final controller = TextEditingController(text: currentName);
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Edit Ruangan'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Nama ruangan',
          filled: true,
          fillColor: AppTheme.neutral50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              Navigator.pop(ctx);
              ref.read(roomsProvider.notifier).updateRoom(roomId, name);
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}
