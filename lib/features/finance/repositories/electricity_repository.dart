import '../models/electricity_purchase.dart';

abstract class IElectricityRepository {
  Future<List<ElectricityPurchase>> getPurchases();
  Future<void> addPurchase(int amount, String purchasedBy, String? proofPhoto);
  Future<void> verifyPurchase(String purchaseId);
}

class MockElectricityRepository implements IElectricityRepository {
  final List<ElectricityPurchase> _purchases = [];

  MockElectricityRepository() {
    _seed();
  }

  void _seed() {
    final now = DateTime.now();
    _purchases.add(ElectricityPurchase(
      id: 'el1',
      amount: 100000,
      purchasedBy: 'Budi',
      date: now.subtract(const Duration(days: 5)),
      isVerified: true,
    ));
    _purchases.add(ElectricityPurchase(
      id: 'el2',
      amount: 200000,
      purchasedBy: 'Juan',
      date: now.subtract(const Duration(days: 12)),
      proofPhoto: 'https://via.placeholder.com/400',
    ));
    _purchases.add(ElectricityPurchase(
      id: 'el3',
      amount: 50000,
      purchasedBy: 'Rizki',
      date: now.subtract(const Duration(days: 20)),
    ));
    _purchases.add(ElectricityPurchase(
      id: 'el4',
      amount: 150000,
      purchasedBy: 'Dika',
      date: now.subtract(const Duration(days: 30)),
      isVerified: true,
    ));
    _purchases.sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<ElectricityPurchase>> getPurchases() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _purchases;
  }

  @override
  Future<void> addPurchase(int amount, String purchasedBy, String? proofPhoto) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _purchases.insert(0, ElectricityPurchase(
      id: 'el_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      purchasedBy: purchasedBy,
      date: DateTime.now(),
      proofPhoto: proofPhoto,
    ));
  }

  @override
  Future<void> verifyPurchase(String purchaseId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _purchases.indexWhere((p) => p.id == purchaseId);
    if (idx != -1) {
      _purchases[idx] = _purchases[idx].copyWith(isVerified: true);
    }
  }
}
