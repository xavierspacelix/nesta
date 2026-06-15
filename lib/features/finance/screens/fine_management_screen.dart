import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/finance/models/fine_entry.dart';
import 'package:nesta/features/finance/providers/fine_provider.dart';

class FineManagementScreen extends ConsumerWidget {
  const FineManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFinesAsync = ref.watch(currentFinesProvider);
    final historyAsync = ref.watch(fineHistoryProvider);
    final totalAsync = ref.watch(monthlyFineTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Denda'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, totalAsync),
              const SizedBox(height: 24),
              const Text('Denda Aktif', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 12),
              currentFinesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => _buildErrorCard(context),
                data: (fines) => fines.isEmpty
                    ? _buildEmptyFines(context)
                    : Column(
                        children: fines.map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _FineCard(fine: f, onPay: () => context.push('/fine/${f.id}')),
                        )).toList(),
                      ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Riwayat', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
                ],
              ),
              const SizedBox(height: 8),
              historyAsync.when(
                loading: () => const SizedBox(),
                error: (e, _) => const SizedBox(),
                data: (history) => Column(
                  children: history.take(4).map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _HistoryTile(fine: f),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AsyncValue<int> totalAsync) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Denda Bulan Ini',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          totalAsync.when(
            loading: () => const SizedBox(height: 32, child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))),
            error: (e, _) => const Text('Rp 0', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
            data: (total) => Text(
              'Rp ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _badge('Belum Dibayar', Icons.warning_amber_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildEmptyFines(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: const Column(
        children: [
          Icon(Icons.check_circle_outline_rounded, size: 40, color: AppTheme.success),
          SizedBox(height: 8),
          Text('Tidak ada denda aktif', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          SizedBox(height: 4),
          Text('Semua tugas diselesaikan dengan baik!', style: TextStyle(fontSize: 13, color: AppTheme.neutral500)),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text('Gagal memuat data', style: TextStyle(color: AppTheme.error)),
    );
  }
}

class _FineCard extends StatelessWidget {
  final FineEntry fine;
  final VoidCallback onPay;

  const _FineCard({required this.fine, required this.onPay});

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AppTheme.error, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fine.reason, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 7,
                        backgroundColor: AppTheme.primary.withOpacity(0.15),
                        child: Text(fine.memberName[0],
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                      ),
                      const SizedBox(width: 4),
                      Text(fine.memberName, style: const TextStyle(fontSize: 12, color: AppTheme.neutral500)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(fine.formattedAmount,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.error)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text('Belum Dibayar',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.warning)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final FineEntry fine;

  const _HistoryTile({required this.fine});

  @override
  Widget build(BuildContext context) {
    final monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${fine.date.day}',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              Text(monthNames[fine.date.month],
                  style: const TextStyle(fontSize: 10, color: AppTheme.neutral500, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 32, color: AppTheme.neutral200),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fine.reason, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                const SizedBox(height: 2),
                Text(fine.memberName, style: const TextStyle(fontSize: 11, color: AppTheme.neutral500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(fine.formattedAmount,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.success)),
          ),
        ],
      ),
    );
  }
}
