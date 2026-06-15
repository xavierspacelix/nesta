import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/analytics/models/analytics_data.dart';
import 'package:nesta/features/analytics/providers/analytics_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analitik Rumah'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: analyticsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Gagal memuat data')),
        data: (data) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildCompletionCard(data.completionRate),
              const SizedBox(height: 16),
              _buildActiveMemberCard(
                data.mostActiveMember,
                data.activeMemberTaskCount,
              ),
              const SizedBox(height: 16),
              _buildMissedTasksCard(data.mostMissedRoom, data.missedTaskCount),
              const SizedBox(height: 16),
              _buildMonthlyFinesCard(data.monthlyFines),
              const SizedBox(height: 16),
              _buildRoomScoresCard(data.roomScores),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionCard(double rate) {
    final pct = (rate * 100).toStringAsFixed(0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral200.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.success,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Tugas Selesai',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '$pct%',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 36,
                  color: AppTheme.success,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: rate,
                        strokeWidth: 10,
                        backgroundColor: AppTheme.neutral100,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.success,
                        ),
                      ),
                    ),
                    Text(
                      '$pct%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Bulan ini',
            style: TextStyle(fontSize: 13, color: AppTheme.neutral500),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveMemberCard(String name, int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral200.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: AppTheme.warning,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Anggota Paling Aktif',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.warning.withOpacity(0.15),
                child: Text(
                  name[0],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppTheme.warning,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$count tugas selesai',
                    style: TextStyle(fontSize: 13, color: AppTheme.neutral500),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '#1',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.warning,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissedTasksCard(String room, int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral200.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppTheme.error,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Tugas Paling Sering Terlewat',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: AppTheme.error,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$count kali terlewat bulan ini',
                    style: TextStyle(fontSize: 13, color: AppTheme.neutral500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyFinesCard(int fines) {
    final formatted = fines.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white70,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Total Denda Bulan Ini',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Rp $formatted',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Dari 5 anggota',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomScoresCard(List<RoomScore> roomScores) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral200.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.cleaning_services_rounded,
                color: AppTheme.secondary,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Skor Kebersihan per Ruangan',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...roomScores.map((rs) {
            final pct = (rs.score * 100).toStringAsFixed(0);
            final color = rs.score >= 0.8
                ? AppTheme.success
                : rs.score >= 0.6
                ? AppTheme.warning
                : AppTheme.error;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rs.roomName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$pct%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: rs.score,
                      minHeight: 8,
                      backgroundColor: AppTheme.neutral100,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
