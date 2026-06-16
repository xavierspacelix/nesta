import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/schedule/models/schedule_entry.dart';
import 'package:nesta/features/schedule/providers/schedule_provider.dart';

final _selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final _monthOffsetProvider = StateProvider<int>((ref) => 0);

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);
    final selectedDate = ref.watch(_selectedDateProvider);
    final view = ref.watch(scheduleViewProvider);
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
            _buildViewToggle(context, ref, view),
            _buildHeader(context, ref, view, selectedDate, monday),
            Expanded(
              child: scheduleAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Gagal memuat jadwal')),
                data: (entries) => RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(scheduleProvider);
                    await ref.read(scheduleProvider.future);
                  },
                  child: switch (view) {
                    ScheduleView.today => _TodayView(entries: entries),
                    ScheduleView.weekly => _WeeklyView(
                      entries: entries,
                      selectedDate: selectedDate,
                      monday: monday,
                      onDateChanged: (d) => ref.read(_selectedDateProvider.notifier).state = d,
                    ),
                    ScheduleView.monthly => _MonthlyView(
                      entries: entries,
                      selectedDate: selectedDate,
                      onDateChanged: (d) => ref.read(_selectedDateProvider.notifier).state = d,
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context, WidgetRef ref, ScheduleView view) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<ScheduleView>(
          segments: const [
            ButtonSegment(value: ScheduleView.today, label: Text('Harian'), icon: Icon(Icons.today_rounded, size: 16)),
            ButtonSegment(value: ScheduleView.weekly, label: Text('Mingguan'), icon: Icon(Icons.calendar_view_week_rounded, size: 16)),
            ButtonSegment(value: ScheduleView.monthly, label: Text('Bulanan'), icon: Icon(Icons.calendar_month_rounded, size: 16)),
          ],
          selected: {view},
          onSelectionChanged: (v) {
            ref.read(scheduleViewProvider.notifier).state = v.first;
            if (v.first != ScheduleView.weekly) {
              ref.read(_selectedDateProvider.notifier).state = DateTime.now();
            }
          },
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, ScheduleView view, DateTime selected, DateTime monday) {
    final monthNames = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (view == ScheduleView.monthly)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final offset = ref.read(_monthOffsetProvider.notifier);
                        offset.state = offset.state - 1;
                      },
                      child: const Icon(Icons.chevron_left_rounded, color: AppTheme.neutral500),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${monthNames[selected.month]} ${selected.year}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        final offset = ref.read(_monthOffsetProvider.notifier);
                        offset.state = offset.state + 1;
                      },
                      child: const Icon(Icons.chevron_right_rounded, color: AppTheme.neutral500),
                    ),
                  ],
                )
              else
                Text(
                  '${monthNames[selected.month]} ${selected.year}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.neutral500),
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
          if (view == ScheduleView.weekly) ...[
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
        ],
      ),
    );
  }

  DateTime _mondayOf(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _TodayView extends StatelessWidget {
  final List<ScheduleEntry> entries;

  const _TodayView({required this.entries});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayEntries = entries.where((e) =>
      e.date.year == today.year &&
      e.date.month == today.month &&
      e.date.day == today.day,
    ).toList();

    if (todayEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_outlined, size: 56, color: AppTheme.neutral300),
            const SizedBox(height: 12),
            Text('Tidak ada piket', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Tidak ada tugas untuk hari ini',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral500)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      itemCount: todayEntries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _TaskCard(entry: todayEntries[index]),
    );
  }
}

class _WeeklyView extends StatelessWidget {
  final List<ScheduleEntry> entries;
  final DateTime selectedDate;
  final DateTime monday;
  final ValueChanged<DateTime> onDateChanged;

  const _WeeklyView({
    required this.entries,
    required this.selectedDate,
    required this.monday,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dayNames = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

    final dayEntries = entries.where((e) =>
      e.date.year == selectedDate.year &&
      e.date.month == selectedDate.month &&
      e.date.day == selectedDate.day,
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            '${dayNames[selectedDate.weekday]}, ${selectedDate.day}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: dayEntries.isEmpty
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
                  itemCount: dayEntries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _TaskCard(entry: dayEntries[index]),
                ),
        ),
      ],
    );
  }
}

class _MonthlyView extends ConsumerWidget {
  final List<ScheduleEntry> entries;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _MonthlyView({
    required this.entries,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offset = ref.watch(_monthOffsetProvider);
    final now = DateTime.now();
    final gridMonth = DateTime(now.year, now.month + offset, 1);
    final today = DateTime.now();
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    final daysInMonth = DateTime(gridMonth.year, gridMonth.month + 1, 0).day;
    final firstWeekday = DateTime(gridMonth.year, gridMonth.month, 1).weekday;

    final dayNames = ['', 'S', 'S', 'R', 'K', 'J', 'S', 'M'];

    final myEntries = currentUserId != null
        ? entries.where((e) => e.assignedTo == currentUserId).toList()
        : <ScheduleEntry>[];

    final dayEntries = entries.where((e) =>
      e.date.year == selectedDate.year &&
      e.date.month == selectedDate.month &&
      e.date.day == selectedDate.day,
    ).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.neutral50,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: dayNames.skip(1).map((d) => Expanded(
                    child: Center(
                      child: Text(d, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.neutral500)),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 8),
                ...List.generate(_weeksInMonth(daysInMonth, firstWeekday), (weekIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: List.generate(7, (dayIndex) {
                        final dayNum = weekIndex * 7 + dayIndex - firstWeekday + 2;
                        if (dayNum < 1 || dayNum > daysInMonth) {
                          return const Expanded(child: SizedBox());
                        }
                        final cellDate = DateTime(gridMonth.year, gridMonth.month, dayNum);
                        final isToday = _isSameDayLocal(cellDate, today);
                        final isSelected = _isSameDayLocal(cellDate, selectedDate);
                        final isPast = !isToday && cellDate.isBefore(today);
                        final myDayEntries = myEntries.where((e) =>
                          e.date.year == cellDate.year &&
                          e.date.month == cellDate.month &&
                          e.date.day == dayNum,
                        ).toList();
                        final hasTask = myDayEntries.isNotEmpty;
                        final allCompleted = myDayEntries.every((e) => e.status == ScheduleStatus.completed);
                        final dotColor = hasTask
                            ? (allCompleted
                                ? AppTheme.success
                                : (isPast ? AppTheme.error : AppTheme.warning))
                            : null;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => onDateChanged(cellDate),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primary : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '$dayNum',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : isToday
                                              ? AppTheme.primary
                                              : AppTheme.neutral800,
                                    ),
                                  ),
                                  if (hasTask && dotColor != null) ...[
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _dot(dotColor),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (dayEntries.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_dayNameLocal(selectedDate.weekday)}, ${selectedDate.day}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            const SizedBox(height: 12),
            ...dayEntries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TaskCard(entry: e),
            )),
          ],
        ],
      ),
    );
  }

  int _weeksInMonth(int days, int firstWeekday) {
    return ((days + firstWeekday - 1) / 7).ceil();
  }

  bool _isSameDayLocal(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _dot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  String _dayNameLocal(int weekday) {
    const names = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return names[weekday];
  }
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
    final isPast = !isToday && entry.date.isBefore(today);
    final statusColor = switch (entry.status) {
      ScheduleStatus.completed => AppTheme.success,
      ScheduleStatus.missed => AppTheme.error,
      ScheduleStatus.pending => isToday ? AppTheme.primary : (isPast ? AppTheme.error : AppTheme.warning),
    };
    final statusIcon = switch (entry.status) {
      ScheduleStatus.completed => Icons.check_circle_rounded,
      ScheduleStatus.missed => Icons.cancel_rounded,
      ScheduleStatus.pending => isToday ? Icons.hourglass_empty_rounded : (isPast ? Icons.cancel_rounded : Icons.schedule_rounded),
    };
    final statusLabel = switch (entry.status) {
      ScheduleStatus.completed => 'Selesai',
      ScheduleStatus.missed => 'Terlewat',
      ScheduleStatus.pending => isToday ? 'Belum Dikerjakan' : (isPast ? 'Terlewat' : 'Akan Datang'),
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
