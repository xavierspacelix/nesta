import '../models/schedule_entry.dart';
import '../models/upcoming_task.dart';

abstract class IScheduleRepository {
  Future<List<ScheduleEntry>> getTodaySchedule();
  Future<List<ScheduleEntry>> getWeeklySchedule();
  Future<List<ScheduleEntry>> getMonthlySchedule();
  Future<List<UpcomingTask>> getUpcomingTasks();
  Future<void> initSchedule();
}

class MockScheduleRepository implements IScheduleRepository {
  final List<ScheduleEntry> _entries = [];
  late final DateTime _today;

  MockScheduleRepository() {
    _today = DateTime.now();
    _seedData();
  }

  void _seedData() {
    final members = ['Budi', 'Juan', 'Rizki', 'Dika', 'Fajar'];
    final rooms = ['Kamar Utama', 'Dapur', 'Kamar Mandi', 'Ruang Tengah', 'Teras'];
    final now = _today;

    for (int dayOffset = -3; dayOffset < 30; dayOffset++) {
      final date = DateTime(now.year, now.month, now.day + dayOffset);
      final roomIndex = (dayOffset + 30) % rooms.length;
      final memberIndex = (dayOffset + 30) % members.length;

      ScheduleStatus status;
      if (date.isAfter(now)) {
        status = ScheduleStatus.pending;
      } else if (dayOffset % 3 == 0) {
        status = ScheduleStatus.missed;
      } else {
        status = ScheduleStatus.completed;
      }

      _entries.add(ScheduleEntry(
        id: 'sched_$dayOffset',
        date: date,
        roomName: rooms[roomIndex],
        assignedUser: members[memberIndex],
        status: status,
      ));
    }
  }

  @override
  Future<List<ScheduleEntry>> getTodaySchedule() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final today = DateTime(_today.year, _today.month, _today.day);
    return _entries.where((e) =>
        e.date.year == today.year &&
        e.date.month == today.month &&
        e.date.day == today.day
    ).toList();
  }

  @override
  Future<List<ScheduleEntry>> getWeeklySchedule() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final weekStart = _today.subtract(Duration(days: _today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return _entries.where((e) =>
        e.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        e.date.isBefore(weekEnd.add(const Duration(days: 1)))
    ).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Future<List<ScheduleEntry>> getMonthlySchedule() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _entries.where((e) =>
        e.date.year == _today.year &&
        e.date.month == _today.month
    ).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Future<List<UpcomingTask>> getUpcomingTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final tomorrow = _today.add(const Duration(days: 1));
    final nextEntries = _entries.where((e) =>
        e.date.isAfter(_today) &&
        !e.date.isAfter(_today.add(const Duration(days: 7)))
    ).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return nextEntries.map((e) {
      final dayNames = ['', 'MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];
      return UpcomingTask(
        id: e.id,
        dayLabel: dayNames[e.date.weekday],
        dateLabel: '${e.date.day}',
        areaName: e.roomName,
        assignedUser: e.assignedUser,
        completedItems: 2,
        totalItems: 5,
      );
    }).toList();
  }

  @override
  Future<void> initSchedule() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
