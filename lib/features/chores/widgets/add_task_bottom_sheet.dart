import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/chores/providers/room_provider.dart';

Future<void> showAddTaskBottomSheet(
    BuildContext context, WidgetRef ref, String roomId) {
  final controller = TextEditingController();
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tambah Tugas',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Nama tugas',
              filled: true,
              fillColor: AppTheme.neutral50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final title = controller.text.trim();
                if (title.isNotEmpty) {
                  Navigator.pop(ctx);
                  ref
                      .read(checklistProvider(roomId).notifier)
                      .addItem(title);
                }
              },
              child: const Text('Tambah'),
            ),
          ),
        ],
      ),
    ),
  );
}
