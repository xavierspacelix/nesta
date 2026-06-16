import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/storage_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/core/utils/image_picker_helper.dart';
import 'package:nesta/features/activity/providers/activity_provider.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';
import 'package:nesta/features/finance/models/rent_record.dart';
import 'package:nesta/features/finance/providers/rent_provider.dart';
import 'package:nesta/features/finance/providers/finance_provider.dart';
import 'package:nesta/features/members/providers/members_provider.dart';
import 'package:nesta/core/widgets/auth_image.dart';

class RentScreen extends ConsumerWidget {
  const RentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentAsync = ref.watch(rentHistoryProvider);
    final authState = ref.watch(authProvider);
    final selectedDate = ref.watch(selectedMonthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sewa + WiFi'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: rentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Gagal memuat data')),
        data: (records) {
          final match = records.where(
            (r) => r.year == selectedDate.year && r.month == selectedDate.month,
          );

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(rentHistoryProvider);
              await ref.read(rentHistoryProvider.future);
            },
            child: match.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: AppTheme.neutral300,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada catatan sewa',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.neutral500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Atur biaya sewa dan WiFi di Kelola Rumah',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.neutral400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _RentMonthCard(
                      record: match.first,
                      currentUserName: authState.userName,
                      onMemberTap: (memberName) {
                        final payment = match.first.payments.firstWhereOrNull(
                          (p) => p.memberName == memberName,
                        );
                        if (payment == null) return;
                        _showPaymentSheet(
                          context,
                          ref,
                          match.first,
                          payment,
                        );
                      },
                    ),
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.invalidate(rentHistoryProvider);
          context.push('/settings/house/manage');
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.tune_rounded),
        label: const Text('Atur Biaya'),
      ),
    );
  }

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  void _showPaymentSheet(
    BuildContext context,
    WidgetRef ref,
    RentRecord record,
    MemberPayment payment,
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
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.primary.withOpacity(0.15),
                  child: Text(
                    payment.memberName[0],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  payment.memberName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp${_formatRupiah(record.perMemberAmount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sewa Rp${_formatRupiah(record.totalRent)} + WiFi Rp${_formatRupiah(record.totalWifi)}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.neutral500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (record.bankName != null)
                    Text(
                      '${record.bankName} — ${record.bankAccountNumber}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.neutral600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (payment.isPaid) ...[
              if (payment.proofPhoto != null) ...[
                GestureDetector(
                  onTap: () => _showProofImage(ctx, payment.proofPhoto!),
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
                        imageUrl: payment.proofPhoto!,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              _buildPaidInfoCard(),
            ] else if (payment.isPendingVerification && isAdmin)
              _buildAdminPendingVerificationCard(
                context,
                ref,
                record,
                payment,
              )
            else if (payment.isPendingVerification)
              _buildMyPendingVerificationCard(context, payment)
            else
              _buildUploadButton(context, ref, record, payment, ctx),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPaidInfoCard() {
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
            'Pembayaran Lunas',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPendingVerificationCard(BuildContext context, MemberPayment payment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 20,
                color: AppTheme.warning,
              ),
              SizedBox(width: 8),
              Text(
                'Menunggu Verifikasi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Pemilik rumah akan memverifikasi pembayaran Anda',
            style: TextStyle(fontSize: 12, color: AppTheme.neutral500),
          ),
          if (payment.proofPhoto != null) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _showProofImage(context, payment.proofPhoto!),
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.neutral200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AuthImage(
                    imageUrl: payment.proofPhoto!,
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdminPendingVerificationCard(
    BuildContext context,
    WidgetRef ref,
    RentRecord record,
    MemberPayment payment,
  ) {
    return Column(
      children: [
        if (payment.proofPhoto != null) ...[
          GestureDetector(
            onTap: () => _showProofImage(context, payment.proofPhoto!),
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
                  imageUrl: payment.proofPhoto!,
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () async {
              try {
                await ref
                    .read(rentRepositoryProvider)
                    .verifyPayment(record.year, record.month, payment.memberId);
                final authState = ref.read(authProvider);
                final activityRepo = ref.read(activityRepositoryProvider);
                if (authState.houseId != null) {
                  await activityRepo.createActivity(
                    houseId: authState.houseId!,
                    userId: authState.userId ?? '',
                    description: 'memverifikasi pembayaran kamu',
                    category: 'fine',
                    targetUserId: payment.memberId,
                  );
                }
                ref.invalidate(rentHistoryProvider);
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pembayaran diverifikasi')),
                );
              } catch (e) {
                Log.e('RentVerify', 'verifyPayment failed', e);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gagal memverifikasi pembayaran'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.verified_rounded, size: 20),
            label: const Text(
              'Verifikasi Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton(
    BuildContext context,
    WidgetRef ref,
    RentRecord record,
    MemberPayment payment,
    BuildContext ctx,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () async {
          final picked = await ImagePickerHelper.pickFromGallery();
          if (picked == null) return;
          try {
            final storage = ref.read(storageServiceProvider);
            final url = await storage.uploadFile(
              folder: 'rent-proof',
              fileName: picked.fileName,
              bytes: picked.bytes,
            );
            await ref
                .read(rentRepositoryProvider)
                .uploadProof(record.year, record.month, payment.memberId, url);
            final authState = ref.read(authProvider);
            final activityRepo = ref.read(activityRepositoryProvider);
            if (authState.houseId != null) {
              await activityRepo.createActivity(
                  houseId: authState.houseId!,
                  userId: authState.userId ?? '',
                  description: 'melakukan pembayaran sewa',
                  category: 'fine',
                );
            }
            ref.invalidate(rentHistoryProvider);
            if (ctx.mounted) Navigator.pop(ctx);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bukti transfer berhasil diupload')),
            );
          } catch (e) {
            Log.e('RentUpload', 'upload failed', e);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal upload bukti transfer')),
            );
          }
        },
        icon: const Icon(Icons.upload_rounded, size: 20),
        label: const Text(
          'Upload Bukti Transfer',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
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
}

class _RentMonthCard extends StatelessWidget {
  final RentRecord record;
  final String? currentUserName;
  final void Function(String memberName) onMemberTap;

  const _RentMonthCard({
    required this.record,
    required this.currentUserName,
    required this.onMemberTap,
  });

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final allPaid = record.payments.every((p) => p.isPaid);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral200.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: allPaid ? AppTheme.success.withOpacity(0.05) : null,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${monthNames[record.month]} ${record.year}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sewa Rp${_formatRupiah(record.totalRent)} + WiFi Rp${_formatRupiah(record.totalWifi)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.neutral500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (allPaid ? AppTheme.success : AppTheme.warning)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    allPaid ? 'Lunas' : 'Belum',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: allPaid ? AppTheme.success : AppTheme.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.neutral50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Per orang',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.neutral500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Rp${_formatRupiah(record.perMemberAmount)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      if (record.bankName != null ||
                          record.bankAccountNumber != null) ...[
                        const Divider(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.account_balance_rounded,
                              size: 14,
                              color: AppTheme.neutral400,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              record.bankName != null &&
                                      record.bankAccountNumber != null
                                  ? '${record.bankName} — ${record.bankAccountNumber}'
                                  : '${record.bankName ?? ''}${record.bankAccountNumber ?? ''}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pembayaran per Orang',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutral500,
                  ),
                ),
                const SizedBox(height: 6),
                ...record.payments.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _MemberPaymentTile(
                      payment: p,
                      perMemberAmount: record.perMemberAmount,
                      isCurrentUser: p.memberName == currentUserName,
                      onTap: () => onMemberTap(p.memberName),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberPaymentTile extends StatelessWidget {
  final MemberPayment payment;
  final int perMemberAmount;
  final bool isCurrentUser;
  final VoidCallback onTap;

  const _MemberPaymentTile({
    required this.payment,
    required this.perMemberAmount,
    required this.isCurrentUser,
    required this.onTap,
  });

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final tileColor = payment.isPaid
        ? AppTheme.success.withOpacity(0.05)
        : payment.isPendingVerification
        ? AppTheme.warning.withOpacity(0.05)
        : null;

    String statusLabel;
    Color statusColor;
    IconData? statusIcon;

    if (payment.isPaid) {
      statusLabel = 'Lunas';
      statusColor = AppTheme.success;
      statusIcon = Icons.check_circle_rounded;
    } else if (payment.isPendingVerification) {
      statusLabel = 'Menunggu';
      statusColor = AppTheme.warning;
      statusIcon = Icons.access_time_rounded;
    } else {
      statusLabel = 'Belum';
      statusColor = AppTheme.warning;
      statusIcon = null;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: tileColor,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: AppTheme.primary.withOpacity(0.15),
              child: Text(
                payment.memberName[0],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        payment.memberName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Anda',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    'Rp${_formatRupiah(perMemberAmount)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: payment.isPaid
                          ? AppTheme.success
                          : AppTheme.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (payment.proofPhoto != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.image_rounded,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (statusIcon != null) ...[
                        Icon(statusIcon, size: 10, color: statusColor),
                        const SizedBox(width: 3),
                      ],
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
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
