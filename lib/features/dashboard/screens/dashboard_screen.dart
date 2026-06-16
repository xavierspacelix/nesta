import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/update_provider.dart';
import 'package:nesta/core/widgets/update_dialog.dart';
import 'package:nesta/features/chores/models/chore.dart';
import 'package:nesta/features/chores/providers/chores_provider.dart';
import 'package:nesta/features/finance/providers/finance_provider.dart';
import 'package:nesta/features/activity/providers/activity_provider.dart';
import 'package:nesta/features/members/providers/members_provider.dart';
import 'package:nesta/features/house/providers/house_provider.dart';
import 'package:nesta/features/schedule/models/upcoming_task.dart';
import 'package:nesta/features/schedule/providers/schedule_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _hasCheckedUpdate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedUpdate) {
      _hasCheckedUpdate = true;
      _checkForUpdate();
    }
  }

  Future<void> _checkForUpdate() async {
    final result = await ref.read(updateCheckProvider.future);
    if (!mounted) return;

    if (result.status == UpdateStatus.upToDate || result.version == null) return;

    showDialog(
      context: context,
      barrierDismissible: result.status != UpdateStatus.force,
      builder: (_) => UpdateDialog(
        version: result.version!,
        isForce: result.status == UpdateStatus.force,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentProfileProvider);
            await ref.read(currentProfileProvider.future);
            ref.invalidate(houseProvider);
            await ref.read(houseProvider.future);
            ref.invalidate(houseStatsProvider);
            await ref.read(houseStatsProvider.future);
            ref.invalidate(todayChoresProvider);
            await ref.read(todayChoresProvider.future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref),
                const SizedBox(height: 16),
                _buildManagementRow(context),
                const SizedBox(height: 24),
                _buildTodayDutyCard(context),
                const SizedBox(height: 32),
                _buildStatistics(context),
                const SizedBox(height: 32),
                _buildRecentActivity(context),
                const SizedBox(height: 32),
                _buildUpcomingTasks(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final houseAsync = ref.watch(houseProvider);
    final name = profileAsync.valueOrNull?.name ?? 'User';
    final avatarUrl = profileAsync.valueOrNull?.avatarUrl;
    final houseName = houseAsync.valueOrNull?.name ?? 'Rumahku';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hai, $name! 👋',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              houseName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.neutral500,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.push('/settings'),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.neutral100,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person_outline_rounded, color: AppTheme.neutral500)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayDutyCard(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final choresAsync = ref.watch(todayChoresProvider);

        return choresAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => _buildErrorCard(context, err),
          data: (chores) {
            if (chores.isEmpty) {
              return _buildEmptyCard(context);
            }

            final allDone = chores.every((c) => c.completedTasks >= c.totalTasks);
            if (allDone) {
              return _buildThankYouCard(context);
            }

            final current = chores.firstWhere(
              (c) => c.completedTasks < c.totalTasks,
            );
            final remainingRooms = chores.where((c) => c.completedTasks < c.totalTasks).toList();
            final progress = current.totalTasks > 0 ? current.completedTasks / current.totalTasks : 0.0;
            final remaining = current.totalTasks - current.completedTasks;

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text(
                          'PIKET HARI INI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (remainingRooms.length > 1)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '+${remainingRooms.length - 1} ruangan lagi',
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${remainingRooms.indexOf(current) + 1}/${remainingRooms.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          current.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    remaining > 0
                        ? 'Ada $remaining tugas yang belum diselesaikan.'
                        : 'Semua tugas selesai!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress: ${(progress * 100).toInt()}%',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              borderRadius: BorderRadius.circular(100),
                              minHeight: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      ElevatedButton(
                        onPressed: () => context.push('/task/${current.id}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primary,
                          minimumSize: const Size(100, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(current.isStarted ? 'Lanjut' : 'Mulai'),
                      ),
                    ],
                  ),
                  if (chores.length > 1) ...[
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 16),
                    ...chores.take(3).map((c) => _buildRoomMiniTile(c)),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRoomMiniTile(Chore chore) {
    final done = chore.completedTasks >= chore.totalTasks;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 16,
            color: Colors.white.withOpacity(done ? 0.9 : 0.5),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              chore.title,
              style: TextStyle(
                color: Colors.white.withOpacity(done ? 0.9 : 0.6),
                fontSize: 13,
                fontWeight: done ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(done ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '${chore.completedTasks}/${chore.totalTasks}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(done ? 0.9 : 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 48, color: AppTheme.neutral400),
            SizedBox(height: 16),
            Text(
              'Istirahat Dulu!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'Kamu tidak ada jadwal piket hari ini.',
              style: TextStyle(color: AppTheme.neutral500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThankYouCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.success, Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(Icons.celebration_rounded, size: 48, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Terima Kasih!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Semua piket hari ini sudah selesai. Good job!',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildManagementRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/rooms'),
            icon: const Icon(Icons.settings_outlined, size: 18),
            label: const Text('Atur Ruangan'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final statsAsync = ref.watch(houseStatsProvider);
        return statsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => _buildErrorCard(context, err),
          data: (stats) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Statistik Rumah',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    GestureDetector(
                      onTap: () => context.push('/analytics'),
                      child: Text(
                        'Lihat Detail →',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildStatCard(context, 'Tugas Selesai', stats.completedToday, Icons.check_circle_outline, AppTheme.success)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard(context, 'Denda Aktif', stats.activeFines, Icons.warning_amber_rounded, AppTheme.warning)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildStatCard(context, 'Performa Bulan Ini', stats.monthlyPerformance, Icons.insights_rounded, AppTheme.primary)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard(context, 'Sewa', _sewaDisplay(stats.upcomingBills), Icons.home_work_rounded, _sewaIconColor(stats.upcomingBills), textColor: _sewaTextColor(stats.upcomingBills))),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color iconColor, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutral500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final activityAsync = ref.watch(recentActivityProvider);
        return activityAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => _buildErrorCard(context, err),
          data: (activities) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Aktivitas Terbaru',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () => context.push('/activity'),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...activities.map((activity) {
                  IconData iconData = Icons.notifications_rounded;
                  Color iconColor = AppTheme.primary;
                  if (activity.type == 'chore') {
                    iconData = Icons.cleaning_services_rounded;
                    iconColor = AppTheme.success;
                  } else if (activity.type == 'finance') {
                    iconData = Icons.account_balance_wallet_rounded;
                    iconColor = AppTheme.secondary;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildActivityItem(context, activity.description, activity.timeAgo, iconData, iconColor),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildActivityItem(BuildContext context, String text, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.neutral400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingTasks(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final tasksAsync = ref.watch(upcomingTasksProvider);
        return tasksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => _buildErrorCard(context, err),
          data: (tasks) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jadwal Selanjutnya',
                        style: Theme.of(context).textTheme.headlineSmall),
                    TextButton(
                      onPressed: () => context.push('/schedule'),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _UpcomingCard(task: task);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _sewaDisplay(String value) {
    final idx = value.indexOf('|');
    return idx == -1 ? value : value.substring(0, idx);
  }

  Color _sewaIconColor(String value) {
    if (value == 'Lunas') return AppTheme.primary;
    if (value == '-') return AppTheme.neutral500;
    final idx = value.indexOf('|');
    if (idx == -1) return AppTheme.primary;
    final dueDay = int.tryParse(value.substring(idx + 1));
    if (dueDay == null) return AppTheme.primary;
    final now = DateTime.now();
    if (now.day > dueDay) return AppTheme.error;
    if (now.day >= dueDay - 7) return AppTheme.warning;
    return AppTheme.primary;
  }

  Color? _sewaTextColor(String value) {
    if (value == 'Lunas' || value == '-') return null;
    return _sewaIconColor(value);
  }

  Widget _buildErrorCard(BuildContext context, Object error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppTheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Gagal memuat data. Silakan coba lagi nanti.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final UpcomingTask task;

  const _UpcomingCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(task.dayLabel,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.neutral500)),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.neutral200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(task.dateLabel,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.neutral600)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Spacer(),
            Text(task.areaName,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: task.totalItems > 0 ? task.completedItems / task.totalItems : 0,
                      backgroundColor: AppTheme.neutral200,
                      valueColor: AlwaysStoppedAnimation(AppTheme.success),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${task.completedItems}/${task.totalItems}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.neutral500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: AppTheme.primary.withOpacity(0.15),
                  child: Text(
                    task.assignedUser[0],
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    task.assignedUser,
                    style: TextStyle(fontSize: 12, color: AppTheme.neutral500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
