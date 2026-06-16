import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/storage_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/core/utils/image_picker_helper.dart';
import 'package:nesta/features/activity/providers/activity_provider.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';
import 'package:nesta/features/finance/models/fine_entry.dart';
import 'package:nesta/features/finance/providers/fine_provider.dart';
import 'package:nesta/core/widgets/auth_image.dart';
import 'package:nesta/features/members/providers/members_provider.dart';

class FineSettlementScreen extends ConsumerWidget {
  final String fineId;

  const FineSettlementScreen({super.key, required this.fineId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fineAsync = ref.watch(fineByIdProvider(fineId));
    final authState = ref.watch(authProvider);
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Denda'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: fineAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Gagal memuat data denda')),
        data: (fine) {
          if (fine == null) {
            return const Center(child: Text('Denda tidak ditemukan'));
          }

          final userId = authState.userId;
          final isFinedMember = userId != null && fine.memberId == userId;

          return profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Gagal memuat profil')),
            data: (profile) {
              final isAdmin = profile?.role == 'Owner';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildFineDetailCard(context, fine),
                    const SizedBox(height: 24),
                    if (fine.status == FineStatus.unpaid && isFinedMember)
                      _buildUploadProofButton(context, ref, fine),
                    if (fine.status == FineStatus.pendingVerification && isFinedMember)
                      _buildPendingVerificationCard(context, fine),
                    if (fine.status == FineStatus.pendingVerification && isAdmin) ...[
                      const SizedBox(height: 16),
                      _buildVerifyButton(context, ref, fine),
                    ],
                    if (fine.status == FineStatus.paid) ...[
                      if (fine.proofPhoto != null) ...[
                        GestureDetector(
                          onTap: () => _showProofImage(context, fine.proofPhoto!),
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
                                imageUrl: fine.proofPhoto!,
                                width: double.infinity,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ketuk untuk memperbesar',
                          style: TextStyle(fontSize: 11, color: AppTheme.neutral400),
                        ),
                        const SizedBox(height: 12),
                      ],
                      _buildPaidCard(context),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUploadProofButton(BuildContext context, WidgetRef ref, FineEntry fine) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => _handleUploadProof(context, ref, fine),
        icon: const Icon(Icons.upload_rounded, size: 20),
        label: const Text(
          'Upload Bukti Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }

  Future<void> _handleUploadProof(BuildContext context, WidgetRef ref, FineEntry fine) async {
    final picked = await ImagePickerHelper.pickFromGallery();
    if (picked == null) return;
    try {
      final storage = ref.read(storageServiceProvider);
      final url = await storage.uploadFile(
        folder: 'fine-proofs',
        fileName: picked.fileName,
        bytes: picked.bytes,
      );
      await ref.read(fineRepositoryProvider).uploadProof(fine.id, url);
      final authState = ref.read(authProvider);
      final activityRepo = ref.read(activityRepositoryProvider);
      if (authState.houseId != null) {
        await activityRepo.createActivity(
          houseId: authState.houseId!,
          userId: authState.userId ?? '',
          description: 'melakukan pembayaran denda',
          category: 'fine',
        );
      }
      ref.invalidate(fineByIdProvider(fine.id));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bukti pembayaran berhasil diupload')),
      );
    } catch (e) {
      Log.e('FineUpload', 'upload proof failed', e);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal upload bukti pembayaran')),
      );
    }
  }

  Widget _buildPendingVerificationCard(BuildContext context, FineEntry fine) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time_rounded, color: AppTheme.warning, size: 26),
          ),
          const SizedBox(height: 12),
          const Text(
            'Menunggu Verifikasi',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.warning),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pemilik rumah akan memverifikasi\npembayaran Anda',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.neutral500),
          ),
          if (fine.proofPhoto != null) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _showProofImage(context, fine.proofPhoto!),
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
                    imageUrl: fine.proofPhoto!,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ketuk untuk memperbesar',
              style: TextStyle(fontSize: 11, color: AppTheme.neutral400),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context, WidgetRef ref, FineEntry fine) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => _handleVerify(context, ref, fine),
        icon: const Icon(Icons.verified_rounded, size: 20),
        label: const Text(
          'Verifikasi Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.success,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }

  Future<void> _handleVerify(BuildContext context, WidgetRef ref, FineEntry fine) async {
    try {
      await ref.read(fineRepositoryProvider).verifyPayment(fine.id);
      final authState = ref.read(authProvider);
      final activityRepo = ref.read(activityRepositoryProvider);
      if (authState.houseId != null) {
        await activityRepo.createActivity(
          houseId: authState.houseId!,
          userId: authState.userId ?? '',
          description: 'memverifikasi pembayaran kamu',
          category: 'fine',
          targetUserId: fine.memberId,
        );
      }
      ref.invalidate(fineByIdProvider(fine.id));
      ref.invalidate(currentFinesProvider);
      ref.invalidate(fineHistoryProvider);
      ref.invalidate(monthlyFineTotalProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pembayaran diverifikasi')),
      );
      context.pop();
    } catch (e) {
      Log.e('FineVerify', 'verifyPayment failed', e);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memverifikasi pembayaran')),
      );
    }
  }

  Widget _buildPaidCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
      ),
      child: const Column(
        children: [
          Icon(Icons.check_circle_rounded, size: 48, color: AppTheme.success),
          SizedBox(height: 12),
          Text(
            'Lunas',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppTheme.success),
          ),
          SizedBox(height: 4),
          Text(
            'Denda ini telah dibayar',
            style: TextStyle(fontSize: 13, color: AppTheme.neutral500),
          ),
        ],
      ),
    );
  }

  void _showProofImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => GestureDetector(
        onTap: () => Navigator.pop(ctx),
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text('Bukti Pembayaran'),
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

  Widget _buildFineDetailCard(BuildContext context, FineEntry fine) {
    final monthNames = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: [
          BoxShadow(color: AppTheme.neutral200.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppTheme.error, size: 32),
          ),
          const SizedBox(height: 16),
          const Text('Anda memiliki denda', style: TextStyle(fontSize: 14, color: AppTheme.neutral500)),
          const SizedBox(height: 8),
          Text(
            fine.formattedAmount,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 32, color: AppTheme.error),
          ),
          const SizedBox(height: 4),
          _statusBadge(fine.status),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          _detailRow('Anggota', fine.memberName),
          const SizedBox(height: 8),
          _detailRow('Tanggal', '${fine.date.day} ${monthNames[fine.date.month]} ${fine.date.year}'),
          const SizedBox(height: 8),
          _detailRow('Penyebab', fine.reason),
          const SizedBox(height: 8),
          _detailRow('Progress', '${(fine.completionPercentage * 100).toStringAsFixed(0)}%'),
        ],
      ),
    );
  }

  Widget _statusBadge(FineStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status == FineStatus.paid
            ? AppTheme.success.withOpacity(0.1)
            : status == FineStatus.pendingVerification
                ? AppTheme.warning.withOpacity(0.1)
                : AppTheme.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status == FineStatus.paid
            ? 'Lunas'
            : status == FineStatus.pendingVerification
                ? 'Menunggu Verifikasi'
                : 'Belum Dibayar',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: status == FineStatus.paid ? AppTheme.success : AppTheme.warning,
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
}
