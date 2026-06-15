import '../models/swap_request.dart';

abstract class ISwapRepository {
  Future<List<String>> getMembers();
  Future<List<SwapRequest>> getPendingRequests();
  Future<void> createRequest(String targetMember, DateTime date, String reason);
  Future<void> approveRequest(String requestId);
  Future<void> rejectRequest(String requestId);
}

class MockSwapRepository implements ISwapRepository {
  final List<SwapRequest> _requests = [];

  MockSwapRepository() {
    _seedData();
  }

  void _seedData() {
    _requests.add(SwapRequest(
      id: 'swap_1',
      requesterName: 'Budi',
      targetMemberName: 'Juan',
      scheduleDate: DateTime.now().add(const Duration(days: 2)),
      reason: 'Ada urusan keluarga',
      status: SwapStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ));
    _requests.add(SwapRequest(
      id: 'swap_2',
      requesterName: 'Rizki',
      targetMemberName: 'Budi',
      scheduleDate: DateTime.now().add(const Duration(days: 4)),
      reason: 'Sakit',
      status: SwapStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ));
  }

  @override
  Future<List<String>> getMembers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Budi', 'Juan', 'Rizki', 'Dika', 'Fajar'];
  }

  @override
  Future<List<SwapRequest>> getPendingRequests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _requests.where((r) => r.status == SwapStatus.pending).toList();
  }

  @override
  Future<void> createRequest(String targetMember, DateTime date, String reason) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _requests.add(SwapRequest(
      id: 'swap_${DateTime.now().millisecondsSinceEpoch}',
      requesterName: 'Budi',
      targetMemberName: targetMember,
      scheduleDate: date,
      reason: reason,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<void> approveRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      _requests[idx] = SwapRequest(
        id: _requests[idx].id,
        requesterName: _requests[idx].requesterName,
        targetMemberName: _requests[idx].targetMemberName,
        scheduleDate: _requests[idx].scheduleDate,
        reason: _requests[idx].reason,
        status: SwapStatus.approved,
        createdAt: _requests[idx].createdAt,
      );
    }
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      _requests[idx] = SwapRequest(
        id: _requests[idx].id,
        requesterName: _requests[idx].requesterName,
        targetMemberName: _requests[idx].targetMemberName,
        scheduleDate: _requests[idx].scheduleDate,
        reason: _requests[idx].reason,
        status: SwapStatus.rejected,
        createdAt: _requests[idx].createdAt,
      );
    }
  }
}
