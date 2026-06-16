import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/schedule/models/schedule_entry.dart';
import 'package:nesta/features/schedule/providers/schedule_provider.dart';

final _selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);
    final selectedDate = ref.watch(_selectedDateProvider);
    final monday = _mondayOf(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Piket'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref, selectedDate, monday),
            const SizedBox(height: 8),
            Expanded(
              child: scheduleAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Gagal memuat jadwal')),
                data: (entries) {
                  final dayEntries = entries
                      .where((e) =>
                          e.date.year == selectedDate.year &&
                          e.date.month == selectedDate.month &&
                          e.date.day == selectedDate.day)
                      .toList();
                  return RefreshIndicator(
                    onRefresh: () { ref.refresh(scheduleProvider); return Future.value(); },
                    child: _buildDayContent(context, selectedDate, dayEntries),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, DateTime selected, DateTime monday) {
    final monthNames = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jadwal Piket', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${monthNames[selected.month]} ${selected.year}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.neutral500)),
                ],
              ),
              GestureDetector(
                onTap: () => context.push('/swap/request'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swap_horiz_rounded, size: 14, color: AppTheme.primary),
                      SizedBox(width: 4),
                      Text('Tukar Jadwal',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final day = monday.add(Duration(days: index));
                final isToday = _isSameDay(day, DateTime.now());
                final isSelected = _isSameDay(day, selected);
                return _DayPill(
                  day: day,
                  isToday: isToday,
                  isSelected: isSelected,
                  onTap: () => ref.read(_selectedDateProvider.notifier).state = day,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayContent(BuildContext context, DateTime date, List<ScheduleEntry> entries) {
    final dayNames = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            '${dayNames[date.weekday]}, ${date.day}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy_outlined, size: 56, color: AppTheme.neutral300),
                      const SizedBox(height: 12),
                      Text('Tidak ada piket', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('Tidak ada tugas di hari ini',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral500)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _TaskCard(entry: entries[index]),
                ),
        ),
      ],
    );
  }

  DateTime _mondayOf(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayPill extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayPill({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayNames = ['', 'S', 'S', 'R', 'K', 'J', 'S', 'M'];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 56 : 48,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.neutral50,
          borderRadius: BorderRadius.circular(16),
          border: isToday && !isSelected
              ? Border.all(color: AppTheme.primary, width: 1.5)
              : null,
          boxShadow: isSelected
              ? [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayNames[day.weekday],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white.withOpacity(0.8) : AppTheme.neutral500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${day.day}',
              style: TextStyle(
                fontSize: isSelected ? 18 : 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppTheme.neutral800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final ScheduleEntry entry;

  const _TaskCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isToday = entry.date.year == today.year &&
        entry.date.month == today.month &&
        entry.date.day == today.day;
    final statusColor = switch (entry.status) {
      ScheduleStatus.completed => AppTheme.success,
      ScheduleStatus.missed => AppTheme.error,
      ScheduleStatus.pending => isToday ? AppTheme.primary : AppTheme.warning,
    };
    final statusIcon = switch (entry.status) {
      ScheduleStatus.completed => Icons.check_circle_rounded,
      ScheduleStatus.missed => Icons.cancel_rounded,
      ScheduleStatus.pending => isToday ? Icons.hourglass_empty_rounded : Icons.schedule_rounded,
    };
    final statusLabel = switch (entry.status) {
      ScheduleStatus.completed => 'Selesai',
      ScheduleStatus.missed => 'Terlewat',
      ScheduleStatus.pending => isToday ? 'Belum Dikerjakan' : 'Akan Datang',
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral200.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
          child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/task/${entry.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.roomName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: AppTheme.primary.withOpacity(0.15),
                            child: Text(
                              entry.assignedUser[0],
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(entry.assignedUser,
                              style: TextStyle(fontSize: 13, color: AppTheme.neutral500)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(statusLabel,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
