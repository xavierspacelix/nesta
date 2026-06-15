import '../models/fine_entry.dart';

abstract class IFineRepository {
  Future<List<FineEntry>> getCurrentFines();
  Future<List<FineEntry>> getFineHistory();
  Future<int> getMonthlyTotal();
  Future<FineEntry?> getFineById(String fineId);
  Future<void> markAsPaid(String fineId);
}

class MockFineRepository implements IFineRepository {
  final List<FineEntry> _fines = [];

  MockFineRepository() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    final members = ['Budi', 'Juan', 'Rizki', 'Dika', 'Fajar'];

    for (int i = 0; i < 12; i++) {
      final date = now.subtract(Duration(days: i * 3));
      final pct = [0.0, 0.25, 0.5, 0.75, 1.0][i % 5];
      final amount = ((1.0 - pct) * 50000).round();
      _fines.add(FineEntry(
        id: 'fine_$i',
        memberName: members[i % members.length],
        reason: _reasons[i % _reasons.length],
        amount: amount,
        completionPercentage: pct,
        date: date,
        status: i < 6 ? FineStatus.unpaid : FineStatus.paid,
      ));
    }
  }

  static const _reasons = [
    'Piket Kamar Utama tidak selesai',
    'Piket Dapur terlewat',
    'Piket Kamar Mandi tidak optimal',
    'Tugas Ruang Tengah tidak dikerjakan',
  ];

  @override
  Future<List<FineEntry>> getCurrentFines() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _fines.where((f) => f.status == FineStatus.unpaid).toList();
  }

  @override
  Future<List<FineEntry>> getFineHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _fines.where((f) => f.status == FineStatus.paid).toList();
  }

  @override
  Future<int> getMonthlyTotal() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return _fines
        .where((f) => f.date.month == now.month && f.date.year == now.year)
        .fold<int>(0, (sum, f) => sum + f.amount);
  }

  @override
  Future<FineEntry?> getFineById(String fineId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _fines.firstWhere((f) => f.id == fineId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> markAsPaid(String fineId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _fines.indexWhere((f) => f.id == fineId);
    if (index != -1) {
      _fines[index] = FineEntry(
        id: _fines[index].id,
        memberName: _fines[index].memberName,
        reason: _fines[index].reason,
        amount: _fines[index].amount,
        completionPercentage: _fines[index].completionPercentage,
        date: _fines[index].date,
        status: FineStatus.paid,
      );
    }
  }
}
