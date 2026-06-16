import 'package:collection/collection.dart';
import '../models/rent_record.dart';

abstract class IRentRepository {
  Future<List<RentRecord>> getRentHistory();
  Future<void> markPaid(int year, int month, String memberId);
  Future<void> uploadProof(int year, int month, String memberId, String photoUrl);
  Future<void> verifyPayment(int year, int month, String memberId);
  Future<void> setRentAmounts(int year, int month, int totalRent, int totalWifi, {String? bankName, String? bankAccountNumber, int? dueDate});
}

class MockRentRepository implements IRentRepository {
  final List<RentRecord> _records = [];

  MockRentRepository() {
    _seed();
  }

  void _seed() {
    const defaultDueDate = 5;
    final now = DateTime.now();
    final members = ['Budi', 'Juan', 'Rizki', 'Dika', 'Fajar'];

    for (int i = 0; i < 4; i++) {
      final month = now.month - i;
      final year = now.year;
      final m = month <= 0 ? month + 12 : month;
      final y = month <= 0 ? year - 1 : year;
      final payments = members.mapIndexed((j, name) {
        if (i == 0 && j == 1) {
          return MemberPayment(memberId: 'id_$j', memberName: name, isPaid: false, proofPhoto: 'https://via.placeholder.com/400');
        }
        final paid = i > 1 || (i <= 1 && name == 'Budi');
        return MemberPayment(memberId: 'id_$j', memberName: name, isPaid: paid);
      }).toList();
      _records.add(RentRecord(
        year: y,
        month: m,
        totalRent: 3000000,
        totalWifi: 500000,
        payments: payments,
        isPaid: payments.every((p) => p.isPaid),
        paidAt: payments.every((p) => p.isPaid) ? DateTime(y, m, 28) : null,
        bankName: 'BCA',
        bankAccountNumber: '1234567890',
        dueDate: defaultDueDate,
      ));
    }
  }

  @override
  Future<List<RentRecord>> getRentHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _records;
  }

  @override
  Future<void> markPaid(int year, int month, String memberId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _records.indexWhere((r) => r.year == year && r.month == month);
    if (idx != -1) {
      final record = _records[idx];
      final payments = record.payments.map((p) {
        if (p.memberId == memberId) return p.copyWith(isPaid: true);
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
        dueDate: record.dueDate,
      );
    }
  }

  @override
  Future<void> uploadProof(int year, int month, String memberId, String photoUrl) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _records.indexWhere((r) => r.year == year && r.month == month);
    if (idx != -1) {
      final record = _records[idx];
      final payments = record.payments.map((p) {
        if (p.memberId == memberId) return p.copyWith(proofPhoto: photoUrl);
        return p;
      }).toList();
      _records[idx] = RentRecord(
        year: record.year,
        month: record.month,
        totalRent: record.totalRent,
        totalWifi: record.totalWifi,
        payments: payments,
        isPaid: false,
        paidAt: null,
        bankName: record.bankName,
        bankAccountNumber: record.bankAccountNumber,
        dueDate: record.dueDate,
      );
    }
  }

  @override
  Future<void> verifyPayment(int year, int month, String memberId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _records.indexWhere((r) => r.year == year && r.month == month);
    if (idx != -1) {
      final record = _records[idx];
      final payments = record.payments.map((p) {
        if (p.memberId == memberId) return p.copyWith(isPaid: true);
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
        dueDate: record.dueDate,
      );
    }
  }

  @override
  Future<void> setRentAmounts(int year, int month, int totalRent, int totalWifi, {String? bankName, String? bankAccountNumber, int? dueDate}) async {
    final idx = _records.indexWhere((r) => r.year == year && r.month == month);
    if (idx != -1) {
      final record = _records[idx];
      _records[idx] = RentRecord(
        year: record.year,
        month: record.month,
        totalRent: totalRent,
        totalWifi: totalWifi,
        payments: record.payments,
        isPaid: record.isPaid,
        paidAt: record.paidAt,
        bankName: bankName,
        bankAccountNumber: bankAccountNumber,
        dueDate: dueDate ?? record.dueDate,
      );
    } else {
      _records.add(RentRecord(
        year: year,
        month: month,
        totalRent: totalRent,
        totalWifi: totalWifi,
        payments: [],
        isPaid: false,
        bankName: bankName,
        bankAccountNumber: bankAccountNumber,
        dueDate: dueDate,
      ));
    }
  }
}
