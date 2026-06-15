import '../models/analytics_data.dart';

abstract class IAnalyticsRepository {
  Future<AnalyticsData> getAnalytics();
}

class MockAnalyticsRepository implements IAnalyticsRepository {
  @override
  Future<AnalyticsData> getAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AnalyticsData(
      completionRate: 0.72,
      mostActiveMember: 'Juan',
      activeMemberTaskCount: 18,
      mostMissedRoom: 'Kamar Mandi',
      missedTaskCount: 6,
      monthlyFines: 125000,
      roomScores: [
        RoomScore(roomName: 'Kamar Utama', score: 0.85),
        RoomScore(roomName: 'Dapur', score: 0.78),
        RoomScore(roomName: 'Kamar Mandi', score: 0.45),
        RoomScore(roomName: 'Ruang Tengah', score: 0.70),
        RoomScore(roomName: 'Teras', score: 0.82),
      ],
    );
  }
}
