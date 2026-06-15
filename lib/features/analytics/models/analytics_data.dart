class AnalyticsData {
  final double completionRate;
  final String mostActiveMember;
  final int activeMemberTaskCount;
  final String mostMissedRoom;
  final int missedTaskCount;
  final int monthlyFines;
  final List<RoomScore> roomScores;

  const AnalyticsData({
    required this.completionRate,
    required this.mostActiveMember,
    required this.activeMemberTaskCount,
    required this.mostMissedRoom,
    required this.missedTaskCount,
    required this.monthlyFines,
    required this.roomScores,
  });
}

class RoomScore {
  final String roomName;
  final double score;

  const RoomScore({required this.roomName, required this.score});
}
