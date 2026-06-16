import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/finance/models/water_schedule.dart';
import 'package:nesta/features/finance/providers/water_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';

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
          onRefresh: () { ref.refresh(waterScheduleProvider); return Future.value(); },
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
                    child: _HistoryTile(purchase: h),
                  ),
                ),
              ],
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
                          ref.read(waterRepositoryProvider).markPurchased();
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

  const _HistoryTile({required this.purchase});

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
          const Icon(
            Icons.water_drop_rounded,
            size: 14,
            color: AppTheme.secondary,
          ),
        ],
      ),
    );
  }
}
