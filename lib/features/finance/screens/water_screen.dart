import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/storage_provider.dart';
import 'package:nesta/core/widgets/auth_image.dart';
import 'package:nesta/features/finance/models/water_schedule.dart';
import 'package:nesta/features/finance/providers/water_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/core/utils/image_picker_helper.dart';
import 'package:nesta/features/activity/providers/activity_provider.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';
import 'package:nesta/features/members/providers/members_provider.dart';

class WaterScreen extends ConsumerWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waterAsync = ref.watch(waterScheduleProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galon Air'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: waterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Gagal memuat data')),
        data: (schedule) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(waterScheduleProvider);
            await ref.read(waterScheduleProvider.future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildNextBuyerCard(context, ref, schedule, currentUser),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Text(
                      'Riwayat',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...schedule.history.map(
                  (h) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _HistoryTile(
                      purchase: h,
                      onTap: () => _showDetailSheet(context, ref, h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailSheet(
    BuildContext context,
    WidgetRef ref,
    WaterPurchase purchase,
  ) {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    final isAdmin = profile?.role == 'Owner';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.water_drop_rounded,
                    color: AppTheme.secondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      purchase.buyerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pembelian galon',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.neutral500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _statusBadge(purchase),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow('Tanggal',
                '${purchase.date.day}/${purchase.date.month}/${purchase.date.year}'),
            const SizedBox(height: 20),
            if (purchase.isVerified) ...[
              if (purchase.proofPhoto != null)
                _buildProofPreview(ctx, purchase),
              const SizedBox(height: 12),
              _buildVerifiedCard(),
            ] else if (purchase.proofPhoto != null && isAdmin)
              _buildAdminVerifySection(context, ref, purchase)
            else if (purchase.proofPhoto != null)
              _buildProofPreview(ctx, purchase),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(WaterPurchase purchase) {
    final isPending = purchase.isPendingVerification;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (purchase.isVerified
                ? AppTheme.success
                : isPending
                    ? AppTheme.warning
                    : AppTheme.neutral400)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        purchase.isVerified
            ? 'Terverifikasi'
            : isPending
                ? 'Menunggu'
                : 'Belum',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: purchase.isVerified
              ? AppTheme.success
              : isPending
                  ? AppTheme.warning
                  : AppTheme.neutral500,
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.neutral500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  Widget _buildVerifiedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, size: 20, color: AppTheme.success),
          SizedBox(width: 8),
          Text(
            'Terverifikasi',
            style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.success),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminVerifySection(
    BuildContext context,
    WidgetRef ref,
    WaterPurchase purchase,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showProofFullScreen(context, purchase.proofPhoto!),
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.neutral200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AuthImage(
                imageUrl: purchase.proofPhoto!,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () async {
              try {
                await ref.read(waterRepositoryProvider).verifyPurchase(purchase.id);
                ref.invalidate(waterScheduleProvider);
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pembelian diverifikasi')),
                );
              } catch (e) {
                Log.e('WaterVerify', 'failed', e);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal memverifikasi')),
                );
              }
            },
            icon: const Icon(Icons.verified_rounded, size: 20),
            label: const Text(
              'Verifikasi Pembelian',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProofPreview(BuildContext context, WaterPurchase purchase) {
    return GestureDetector(
      onTap: () => _showProofFullScreen(context, purchase.proofPhoto!),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.neutral200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AuthImage(
            imageUrl: purchase.proofPhoto!,
            width: double.infinity,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showProofFullScreen(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => GestureDetector(
        onTap: () => Navigator.pop(ctx),
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text('Bukti Pembelian'),
          ),
          body: Center(
            child: InteractiveViewer(
              child: AuthImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextBuyerCard(
    BuildContext context,
    WidgetRef ref,
    WaterSchedule schedule,
    String currentUser,
  ) {
    final isMe = schedule.nextBuyer == currentUser;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.secondary, Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Giliran Beli',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            schedule.nextBuyer,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${schedule.daysSinceLastPurchase} hari sejak pembelian terakhir',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (isMe)
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final picked = await ImagePickerHelper.pickFromGallery();
                          if (picked == null) return;
                          final storage = ref.read(storageServiceProvider);
                          final url = await storage.uploadFile(
                            folder: 'water-proof',
                            fileName: picked.fileName,
                            bytes: picked.bytes,
                          );
                          await ref.read(waterRepositoryProvider).markPurchased(proofPhoto: url);
                          final authState = ref.read(authProvider);
                          final activityRepo = ref.read(activityRepositoryProvider);
                          if (authState.houseId != null) {
                            await activityRepo.createActivity(
                              houseId: authState.houseId!,
                              userId: authState.userId ?? '',
                              description: 'membeli galon air',
                              category: 'fine',
                            );
                          }
                          ref.invalidate(waterScheduleProvider);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pembelian galon dicatat!'),
                            ),
                          );
                        } catch (e) {
                          Log.e('Water', 'markPurchased failed', e);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gagal mencatat pembelian'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_circle_rounded, size: 18),
                      label: const Text(
                        'Saya Sudah Beli',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Notifikasi dikirim ke ${schedule.nextBuyer}',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_outlined, size: 18),
                      label: Text(
                        'Ingatkan ${schedule.nextBuyer}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.15),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final WaterPurchase purchase;
  final VoidCallback onTap;

  const _HistoryTile({
    required this.purchase,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
    final date = purchase.date;
    final isPending = purchase.isPendingVerification;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.neutral50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.neutral200),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  monthNames[date.month],
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.neutral500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(width: 1, height: 28, color: AppTheme.neutral200),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 10,
              backgroundColor: AppTheme.secondary.withOpacity(0.15),
              child: Text(
                purchase.buyerName[0],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.secondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              purchase.buyerName,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const Spacer(),
            if (purchase.isVerified)
              const Icon(Icons.verified_rounded, size: 16, color: AppTheme.success)
            else if (isPending)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'Menunggu',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.warning,
                  ),
                ),
              ),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.neutral400),
          ],
        ),
      ),
    );
  }
}
