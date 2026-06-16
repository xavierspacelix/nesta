import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/models/notification_type.dart';
import 'package:nesta/core/providers/notification_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/features/finance/models/fine_entry.dart';
import 'package:nesta/features/finance/providers/fine_provider.dart';

class FineSettlementScreen extends ConsumerWidget {
  final String fineId;

  const FineSettlementScreen({super.key, required this.fineId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fineAsync = ref.watch(fineByIdProvider(fineId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selesaikan Denda'),
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

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildFineDetailCard(context, fine),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await ref.read(fineRepositoryProvider).markAsPaid(fineId);
                        ref.read(notificationServiceProvider).notify(
                          NotificationType.paymentReminder,
                          'Denda Dibayar',
                          'Denda $fineId telah dibayarkan',
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Denda berhasil dibayarkan')),
                        );
                        context.pop();
                      } catch (e) {
                        Log.e('FineSettlement', 'markAsPaid failed', e);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal membayar denda')),
                        );
                      }
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 20),
                    label: const Text('Tandai Sudah Dibayar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
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
            'Rp${fine.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 32, color: AppTheme.error),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              fine.status == FineStatus.unpaid ? 'Belum Dibayar' : 'Lunas',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.warning),
            ),
          ),
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
