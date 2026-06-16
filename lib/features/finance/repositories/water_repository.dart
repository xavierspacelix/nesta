import '../models/water_schedule.dart';

abstract class IWaterRepository {
  Future<WaterSchedule> getSchedule();
  Future<void> markPurchased({String? proofPhoto});
  Future<void> verifyPurchase(String purchaseId);
}

class MockWaterRepository implements IWaterRepository {
  final List<String> _rotation = ['Budi', 'Juan', 'Rizki', 'Dika', 'Fajar'];
  int _currentIndex = 0;
  int _nextId = 1;
  final List<WaterPurchase> _history = [];
  DateTime? _lastDate;

  MockWaterRepository() {
    _lastDate = DateTime.now().subtract(const Duration(days: 5));
    _history.add(WaterPurchase(
      id: (_nextId++).toString(),
      buyerName: 'Fajar',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ));
    _history.add(WaterPurchase(
      id: (_nextId++).toString(),
      buyerName: 'Dika',
      date: DateTime.now().subtract(const Duration(days: 10)),
    ));
    _currentIndex = 0; // Budi is next
  }

  @override
  Future<WaterSchedule> getSchedule() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return WaterSchedule(
      nextBuyer: _rotation[_currentIndex],
      lastBuyer: _history.isNotEmpty ? _history.first.buyerName : '-',
      lastPurchaseDate: _lastDate,
      daysSinceLastPurchase: _lastDate != null ? DateTime.now().difference(_lastDate!).inDays : 0,
      history: _history,
    );
  }

  @override
  Future<void> markPurchased({String? proofPhoto}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final buyer = _rotation[_currentIndex];
    _lastDate = DateTime.now();
    _history.insert(0, WaterPurchase(id: (_nextId++).toString(), buyerName: buyer, date: DateTime.now(), proofPhoto: proofPhoto));
    _currentIndex = (_currentIndex + 1) % _rotation.length;
  }

  @override
  Future<void> verifyPurchase(String purchaseId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _history.indexWhere((p) => p.id == purchaseId);
    if (idx != -1) {
      _history[idx] = _history[idx].copyWith(isVerified: true);
    }
  }
}
