import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/storage_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/core/utils/image_picker_helper.dart';
import 'package:nesta/features/finance/models/rent_record.dart';
import 'package:nesta/features/finance/providers/rent_provider.dart';

class RentScreen extends ConsumerWidget {
  const RentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentAsync = ref.watch(rentHistoryProvider);

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
        data: (records) => RefreshIndicator(
          onRefresh: () => ref.refresh(rentHistoryProvider.future),
          child: records.isEmpty
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
                          style: TextStyle(fontSize: 16, color: AppTheme.neutral500),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Atur biaya sewa dan WiFi di Kelola Rumah',
                          style: TextStyle(fontSize: 13, color: AppTheme.neutral400),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: records.length,
                  itemBuilder: (context, index) => _RentMonthCard(
                    record: records[index],
                    onMemberTap: (memberName) =>
                        _showPaymentSheet(context, ref, records[index], memberName),
                  ),
                ),
        ),
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
    String memberName,
  ) {
    final payment = record.payments.firstWhere(
      (p) => p.memberName == memberName,
    );
    if (payment.isPaid) return;

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
            const Text(
              'Pembayaran Sewa + WiFi',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
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
            const SizedBox(height: 16),
            SizedBox(
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
                    ref.read(rentRepositoryProvider).uploadProof(
                      record.year,
                      record.month,
                      memberName,
                      url,
                    );
                    ref.invalidate(rentHistoryProvider);
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bukti transfer berhasil diupload'),
                      ),
                    );
                  } catch (e) {
                    Log.e('RentUpload', 'upload failed', e);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal upload: $e')),
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
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _RentMonthCard extends StatelessWidget {
  final RentRecord record;
  final void Function(String memberName) onMemberTap;

  const _RentMonthCard({required this.record, required this.onMemberTap});

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
              color: record.isPaid ? AppTheme.success.withOpacity(0.05) : null,
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
                    color: (record.isPaid ? AppTheme.success : AppTheme.warning)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    record.isPaid ? 'Lunas' : 'Belum',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: record.isPaid
                          ? AppTheme.success
                          : AppTheme.warning,
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
                  child: Row(
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
  final VoidCallback onTap;

  const _MemberPaymentTile({
    required this.payment,
    required this.perMemberAmount,
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
    return GestureDetector(
      onTap: payment.isPaid ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: payment.isPaid ? AppTheme.success.withOpacity(0.05) : null,
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
                  Text(
                    payment.memberName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
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
                    color:
                        (payment.isPaid ? AppTheme.success : AppTheme.warning)
                            .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    payment.isPaid ? 'Lunas' : 'Belum',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: payment.isPaid
                          ? AppTheme.success
                          : AppTheme.warning,
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
