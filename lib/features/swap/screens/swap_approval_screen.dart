import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/models/notification_type.dart';
import 'package:nesta/core/providers/notification_provider.dart';
import 'package:nesta/features/activity/providers/activity_provider.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';
import 'package:nesta/features/swap/models/swap_request.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/features/swap/providers/swap_provider.dart';

class SwapApprovalScreen extends ConsumerWidget {
  const SwapApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingSwapsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Persetujuan Tukar'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: pendingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Gagal memuat')),
        data: (requests) => requests.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 64, color: AppTheme.neutral300),
                    const SizedBox(height: 12),
                    const Text('Tidak ada permintaan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('Semua permintaan sudah diproses',
                        style: TextStyle(color: AppTheme.neutral500, fontSize: 13)),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: requests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _SwapRequestCard(
                  request: requests[index],
                  onApprove: () async {
                    try {
                      await ref.read(swapRepositoryProvider).approveRequest(requests[index].id);
                      final req = requests[index];
                      final authState = ref.read(authProvider);
                      final activityRepo = ref.read(activityRepositoryProvider);
                      if (authState.houseId != null) {
                        await activityRepo.createActivity(
                          houseId: authState.houseId!,
                          userId: authState.userId ?? '',
                          description: 'menyetujui tukar jadwal dengan ${req.requesterName}',
                          category: 'swap',
                        );
                      }
                      ref.read(notificationServiceProvider).notify(
                        NotificationType.swapApproved,
                        'Tukar Jadwal Disetujui',
                        '${req.requesterName} — ${req.targetMemberName}',
                      );
                      if (authState.houseId != null) {
                        ref.read(pushNotificationSenderProvider).sendToHouse(
                          houseId: authState.houseId!,
                          title: 'Tukar Jadwal Disetujui',
                          body: '${req.requesterName} — ${req.targetMemberName}',
                        );
                      }
                      ref.invalidate(pendingSwapsProvider);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Permintaan disetujui')),
                      );
                    } catch (e) {
                      Log.e('SwapApproval', 'approve failed', e);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal menyetujui permintaan')),
                      );
                    }
                  },
                  onReject: () async {
                    try {
                      await ref.read(swapRepositoryProvider).rejectRequest(requests[index].id);
                      final req = requests[index];
                      final authState = ref.read(authProvider);
                      final activityRepo = ref.read(activityRepositoryProvider);
                      if (authState.houseId != null) {
                        await activityRepo.createActivity(
                          houseId: authState.houseId!,
                          userId: authState.userId ?? '',
                          description: 'menolak tukar jadwal dengan ${req.requesterName}',
                          category: 'swap',
                        );
                      }
                      ref.read(notificationServiceProvider).notify(
                        NotificationType.swapRejected,
                        'Tukar Jadwal Ditolak',
                        '${req.requesterName} — ${req.targetMemberName}',
                      );
                      if (authState.houseId != null) {
                        ref.read(pushNotificationSenderProvider).sendToHouse(
                          houseId: authState.houseId!,
                          title: 'Tukar Jadwal Ditolak',
                          body: '${req.requesterName} — ${req.targetMemberName}',
                        );
                      }
                      ref.invalidate(pendingSwapsProvider);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Permintaan ditolak')),
                      );
                    } catch (e) {
                      Log.e('SwapApproval', 'reject failed', e);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal menolak permintaan')),
                      );
                    }
                  },
                ),
              ),
      ),
    );
  }
}

class _SwapRequestCard extends StatelessWidget {
  final SwapRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _SwapRequestCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final dayNames = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final date = request.scheduleDate;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: [
          BoxShadow(color: AppTheme.neutral200.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.warning.withOpacity(0.15),
                  child: Text(request.requesterName[0],
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.warning, fontSize: 14)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${request.requesterName} → ${request.targetMemberName}',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('${dayNames[date.weekday]}, ${date.day} ${monthNames[date.month]}',
                          style: const TextStyle(fontSize: 12, color: AppTheme.neutral500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text('Menunggu',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.warning)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.neutral50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notes_rounded, size: 14, color: AppTheme.neutral500),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(request.reason,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppTheme.neutral300),
                        foregroundColor: AppTheme.neutral600,
                      ),
                      child: const Text('Tolak', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: onApprove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Setujui', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
