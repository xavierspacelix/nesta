import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/storage_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/core/utils/image_picker_helper.dart';
import 'package:nesta/features/task_detail/models/checklist_progress.dart';
import 'package:nesta/features/task_detail/providers/task_detail_provider.dart';
import 'package:nesta/features/task_detail/models/task_detail.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat detail tugas')),
        data: (detail) => RefreshIndicator(
          onRefresh: () { ref.refresh(taskDetailProvider(taskId)); return Future.value(); },
          child: _buildContent(context, ref, detail),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, TaskDetail detail) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, detail),
          const SizedBox(height: 24),
          _buildProgressCard(context, detail),
          const SizedBox(height: 24),
          _buildPhotoSection(context, ref, detail),
          const SizedBox(height: 24),
          _buildChecklistSection(context, ref, detail),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: detail.progress == 1.0
                  ? () => context.push('/task/$taskId/verification')
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Selesaikan Tugas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TaskDetail detail) {
    final statusData = switch (detail.status) {
      TaskStatus.completed => (
        AppTheme.success,
        'Selesai',
        Icons.check_circle_rounded,
      ),
      TaskStatus.missed => (AppTheme.error, 'Terlewat', Icons.cancel_rounded),
      TaskStatus.inProgress => (
        AppTheme.primary,
        'Sedang Dikerjakan',
        Icons.rocket_launch_rounded,
      ),
      TaskStatus.pending => (
        AppTheme.warning,
        'Menunggu',
        Icons.schedule_rounded,
      ),
    };
    final dayNames = [
      '',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final monthNames = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.cleaning_services_rounded,
                color: AppTheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.roomName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${dayNames[detail.date.weekday]}, ${detail.date.day} ${monthNames[detail.date.month]} ${detail.date.year}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.neutral500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: AppTheme.primary.withOpacity(0.15),
              child: Text(
                detail.assignedUser[0],
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              detail.assignedUser,
              style: const TextStyle(fontSize: 14, color: AppTheme.neutral600),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusData.$1.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusData.$3, size: 12, color: statusData.$1),
                  const SizedBox(width: 4),
                  Text(
                    statusData.$2,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusData.$1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, TaskDetail detail) {
    final pct = (detail.progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: detail.progress,
                  strokeWidth: 5,
                  backgroundColor: AppTheme.neutral200,
                  valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                ),
                Text(
                  '$pct%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress Pengerjaan',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  '${detail.completedCount} dari ${detail.totalCount} tugas selesai',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.neutral500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(
    BuildContext context,
    WidgetRef ref,
    TaskDetail detail,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Bukti',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PhotoCard(
                label: 'Sebelum',
                photoUrl: detail.beforePhoto,
                onPick: (bytes, fileName) => _uploadEvidence(ref, detail.id, 'before', bytes, fileName),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PhotoCard(
                label: 'Sesudah',
                photoUrl: detail.afterPhoto,
                onPick: (bytes, fileName) => _uploadEvidence(ref, detail.id, 'after', bytes, fileName),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _uploadEvidence(
    WidgetRef ref,
    String taskId,
    String type,
    List<int> bytes,
    String fileName,
  ) async {
    try {
      final storage = ref.read(storageServiceProvider);
      final url = await storage.uploadFile(
        folder: 'task-evidence/$type',
        fileName: fileName,
        bytes: bytes,
      );
      ref.read(taskDetailProvider(taskId).notifier).uploadEvidence(url, type);
    } catch (e) {
      Log.e('TaskEvidence', 'upload $type failed', e);
    }
  }

  Widget _buildChecklistSection(
    BuildContext context,
    WidgetRef ref,
    TaskDetail detail,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daftar Tugas',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            Text(
              '${detail.completedCount}/${detail.totalCount}',
              style: const TextStyle(fontSize: 14, color: AppTheme.neutral500),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...detail.checklist.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ChecklistTile(
              item: item,
              onToggle: () => ref
                  .read(taskDetailProvider(taskId).notifier)
                  .toggleChecklist(item.id),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String label;
  final String? photoUrl;
  final Future<void> Function(List<int> bytes, String fileName)? onPick;

  const _PhotoCard({required this.label, this.photoUrl, this.onPick});

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.neutral300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              const Text('Ambil Foto', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final picked = await ImagePickerHelper.pickFromCamera();
                    if (picked != null && onPick != null) onPick!(picked.bytes, picked.fileName);
                  },
                  icon: const Icon(Icons.camera_alt_rounded, size: 20),
                  label: const Text('Kamera', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final picked = await ImagePickerHelper.pickFromGallery();
                    if (picked != null && onPick != null) onPick!(picked.bytes, picked.fileName);
                  },
                  icon: const Icon(Icons.photo_library_rounded, size: 20),
                  label: const Text('Galeri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            if (onPick != null) {
              _showPicker(context);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (photoUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    photoUrl!,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.broken_image_rounded, size: 32, color: AppTheme.neutral400),
                  ),
                )
              else
                Icon(Icons.camera_alt_outlined, size: 32, color: AppTheme.neutral400),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.neutral600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  final ChecklistItem item;
  final VoidCallback onToggle;

  const _ChecklistTile({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: item.isCompleted
              ? AppTheme.success.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.isCompleted
                ? AppTheme.success.withOpacity(0.3)
                : AppTheme.neutral200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              item.isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: item.isCompleted ? AppTheme.success : AppTheme.neutral400,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: item.isCompleted
                      ? AppTheme.neutral400
                      : AppTheme.neutral800,
                  decoration: item.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
