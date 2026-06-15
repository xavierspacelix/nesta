import '../models/electricity_purchase.dart';

abstract class IElectricityRepository {
  Future<List<ElectricityPurchase>> getPurchases();
  Future<void> addPurchase(int amount, String purchasedBy, String? proofPhoto);
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
    ));
    _purchases.add(ElectricityPurchase(
      id: 'el2',
      amount: 200000,
      purchasedBy: 'Juan',
      date: now.subtract(const Duration(days: 12)),
    ));
    _purchases.add(ElectricityPurchase(
      id: 'el3',
      amount: 50000,
      purchasedBy: 'Rizki',
      date: now.subtract(const Duration(days: 20)),
      proofPhoto: null,
    ));
    _purchases.add(ElectricityPurchase(
      id: 'el4',
      amount: 150000,
      purchasedBy: 'Dika',
      date: now.subtract(const Duration(days: 30)),
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
}
