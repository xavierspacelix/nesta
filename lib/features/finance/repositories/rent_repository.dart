import '../models/rent_record.dart';

abstract class IRentRepository {
  Future<List<RentRecord>> getRentHistory();
  Future<void> markPaid(int year, int month, String memberName);
  Future<void> uploadProof(int year, int month, String memberName, String photoUrl);
  Future<void> setRentAmounts(int year, int month, int totalRent, int totalWifi);
}

class MockRentRepository implements IRentRepository {
  final List<RentRecord> _records = [];

  MockRentRepository() {
    _seed();
  }

  void _seed() {
    final now = DateTime.now();
    final members = ['Budi', 'Juan', 'Rizki', 'Dika', 'Fajar'];

    for (int i = 0; i < 4; i++) {
      final month = now.month - i;
      final year = now.year;
      final m = month <= 0 ? month + 12 : month;
      final y = month <= 0 ? year - 1 : year;
      _records.add(RentRecord(
        year: y,
        month: m,
        totalRent: 3000000,
        totalWifi: 500000,
        payments: members.map((name) => MemberPayment(
          memberName: name,
          isPaid: i > 1 || (i <= 1 && name == 'Budi'),
        )).toList(),
        isPaid: i > 1,
        paidAt: i > 1 ? DateTime(y, m, 28) : null,
        bankName: 'BCA',
        bankAccountNumber: '1234567890',
      ));
    }
  }

  @override
  Future<List<RentRecord>> getRentHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _records;
  }

  @override
  Future<void> markPaid(int year, int month, String memberName) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _records.indexWhere((r) => r.year == year && r.month == month);
    if (idx != -1) {
      final record = _records[idx];
      final payments = record.payments.map((p) {
        if (p.memberName == memberName) return MemberPayment(memberName: p.memberName, isPaid: true);
        return p;
      }).toList();
      final allPaid = payments.every((p) => p.isPaid);
      _records[idx] = RentRecord(
        year: record.year,
        month: record.month,
        totalRent: record.totalRent,
        totalWifi: record.totalWifi,
        payments: payments,
        isPaid: allPaid,
        paidAt: allPaid ? DateTime.now() : null,
        bankName: record.bankName,
        bankAccountNumber: record.bankAccountNumber,
      );
    }
  }

  @override
  Future<void> uploadProof(int year, int month, String memberName, String photoUrl) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _records.indexWhere((r) => r.year == year && r.month == month);
    if (idx != -1) {
      final record = _records[idx];
      final payments = record.payments.map((p) {
        if (p.memberName == memberName) return MemberPayment(memberName: p.memberName, isPaid: true, proofPhoto: photoUrl);
        return p;
      }).toList();
      final allPaid = payments.every((p) => p.isPaid);
      _records[idx] = RentRecord(
        year: record.year,
        month: record.month,
        totalRent: record.totalRent,
        totalWifi: record.totalWifi,
        payments: payments,
        isPaid: allPaid,
        paidAt: allPaid ? DateTime.now() : null,
        bankName: record.bankName,
        bankAccountNumber: record.bankAccountNumber,
      );
    }
  }

  @override
  Future<void> setRentAmounts(int year, int month, int totalRent, int totalWifi) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
