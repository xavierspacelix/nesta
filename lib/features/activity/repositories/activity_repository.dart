import '../models/activity_item.dart';
import '../models/feed_item.dart';

abstract class IActivityRepository {
  Future<List<ActivityItem>> getRecentActivities();
  Future<List<FeedItem>> getFullFeed();
  Future<void> createActivity({
    required String houseId,
    required String userId,
    required String description,
    required String category,
    String? targetUserId,
  });
}

class MockActivityRepository implements IActivityRepository {
  @override
  Future<List<ActivityItem>> getRecentActivities() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      ActivityItem(
        id: '1',
        description: 'Juan menyelesaikan piket Dapur',
        timeAgo: '10 menit yang lalu',
        type: 'chore',
      ),
      ActivityItem(
        id: '2',
        description: 'Dika membeli Galon Air',
        timeAgo: '2 jam yang lalu',
        type: 'finance',
      ),
    ];
  }

  @override
  Future<List<FeedItem>> getFullFeed() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();

    return [
      FeedItem(
        id: 'f1',
        userName: 'Juan',
        userInitial: 'J',
        description: 'Menyelesaikan piket Dapur',
        timestamp: now.subtract(const Duration(minutes: 10)),
        category: FeedCategory.chore,
      ),
      FeedItem(
        id: 'f2',
        userName: 'Dika',
        userInitial: 'D',
        description: 'Membeli Galon Air',
        timestamp: now.subtract(const Duration(hours: 2)),
        category: FeedCategory.fine,
      ),
      FeedItem(
        id: 'f3',
        userName: 'Rizki',
        userInitial: 'R',
        description: 'Mengunggah foto sebelum — Kamar Mandi',
        timestamp: now.subtract(const Duration(hours: 3)),
        category: FeedCategory.photo,
      ),
      FeedItem(
        id: 'f4',
        userName: 'Budi',
        userInitial: 'B',
        description: 'Menukar jadwal dengan Juan',
        timestamp: now.subtract(const Duration(hours: 5)),
        category: FeedCategory.swap,
      ),
      FeedItem(
        id: 'f5',
        userName: 'Fajar',
        userInitial: 'F',
        description: 'Menyelesaikan piket Kamar Utama',
        timestamp: now.subtract(const Duration(hours: 6)),
        category: FeedCategory.chore,
      ),
      FeedItem(
        id: 'f6',
        userName: 'Juan',
        userInitial: 'J',
        description: 'Membayar denda keterlambatan',
        timestamp: now.subtract(const Duration(hours: 8)),
        category: FeedCategory.fine,
      ),
      FeedItem(
        id: 'f7',
        userName: 'Rizki',
        userInitial: 'R',
        description: 'Mengunggah foto sesudah — Kamar Mandi',
        timestamp: now.subtract(const Duration(hours: 9)),
        category: FeedCategory.photo,
      ),
      FeedItem(
        id: 'f8',
        userName: 'Dika',
        userInitial: 'D',
        description: 'Menyelesaikan piket Teras',
        timestamp: now.subtract(const Duration(hours: 12)),
        category: FeedCategory.chore,
      ),
      FeedItem(
        id: 'f9',
        userName: 'Budi',
        userInitial: 'B',
        description: 'Piket Kamar Utama tidak selesai — kena denda',
        timestamp: now.subtract(const Duration(hours: 14)),
        category: FeedCategory.fine,
      ),
      FeedItem(
        id: 'f10',
        userName: 'Fajar',
        userInitial: 'F',
        description: 'Menyelesaikan piket Ruang Tengah',
        timestamp: now.subtract(const Duration(hours: 18)),
        category: FeedCategory.chore,
      ),
      FeedItem(
        id: 'f11',
        userName: 'Juan',
        userInitial: 'J',
        description: 'Mengunggah foto sebelum — Dapur',
        timestamp: now.subtract(const Duration(hours: 20)),
        category: FeedCategory.photo,
      ),
      FeedItem(
        id: 'f12',
        userName: 'Rizki',
        userInitial: 'R',
        description: 'Menukar jadwal dengan Dika',
        timestamp: now.subtract(const Duration(hours: 22)),
        category: FeedCategory.swap,
      ),
      FeedItem(
        id: 'f13',
        userName: 'Budi',
        userInitial: 'B',
        description: 'Menyelesaikan piket Kamar Mandi',
        timestamp: now.subtract(const Duration(days: 1)),
        category: FeedCategory.chore,
      ),
      FeedItem(
        id: 'f14',
        userName: 'Dika',
        userInitial: 'D',
        description: 'Membayar denda piket terlewat',
        timestamp: now.subtract(const Duration(days: 1, hours: 4)),
        category: FeedCategory.fine,
      ),
      FeedItem(
        id: 'f15',
        userName: 'Fajar',
        userInitial: 'F',
        description: 'Menyelesaikan piket Dapur',
        timestamp: now.subtract(const Duration(days: 1, hours: 8)),
        category: FeedCategory.chore,
      ),
      FeedItem(
        id: 'f16',
        userName: 'Juan',
        userInitial: 'J',
        description: 'Mengunggah foto sesudah — Dapur',
        timestamp: now.subtract(const Duration(days: 1, hours: 12)),
        category: FeedCategory.photo,
      ),
      FeedItem(
        id: 'f17',
        userName: 'Rizki',
        userInitial: 'R',
        description: 'Menyelesaikan piket Kamar Utama',
        timestamp: now.subtract(const Duration(days: 2)),
        category: FeedCategory.chore,
      ),
      FeedItem(
        id: 'f18',
        userName: 'Budi',
        userInitial: 'B',
        description: 'Menukar jadwal dengan Fajar',
        timestamp: now.subtract(const Duration(days: 2, hours: 6)),
        category: FeedCategory.swap,
      ),
      FeedItem(
        id: 'f19',
        userName: 'Dika',
        userInitial: 'D',
        description: 'Menyelesaikan piket Kamar Mandi',
        timestamp: now.subtract(const Duration(days: 3)),
        category: FeedCategory.chore,
      ),
      FeedItem(
        id: 'f20',
        userName: 'Fajar',
        userInitial: 'F',
        description: 'Mengunggah foto sebelum — Ruang Tengah',
        timestamp: now.subtract(const Duration(days: 3, hours: 10)),
        category: FeedCategory.photo,
      ),
      FeedItem(
        id: 'f21',
        userName: 'Juan',
        userInitial: 'J',
        description: 'Piket Kamar Mandi terlewat — kena denda',
        timestamp: now.subtract(const Duration(days: 4)),
        category: FeedCategory.fine,
      ),
      FeedItem(
        id: 'f22',
        userName: 'Budi',
        userInitial: 'B',
        description: 'Menyelesaikan piket Dapur',
        timestamp: now.subtract(const Duration(days: 5)),
        category: FeedCategory.chore,
      ),
      FeedItem(
        id: 'f23',
        userName: 'Rizki',
        userInitial: 'R',
        description: 'Menyelesaikan piket Teras',
        timestamp: now.subtract(const Duration(days: 6)),
        category: FeedCategory.chore,
      ),
      FeedItem(
        id: 'f24',
        userName: 'Dika',
        userInitial: 'D',
        description: 'Mengunggah foto sesudah — Teras',
        timestamp: now.subtract(const Duration(days: 7)),
        category: FeedCategory.photo,
      ),
      FeedItem(
        id: 'f25',
        userName: 'Fajar',
        userInitial: 'F',
        description: 'Membayar denda piket tidak selesai',
        timestamp: now.subtract(const Duration(days: 10)),
        category: FeedCategory.fine,
      ),
    ];
  }

  @override
  Future<void> createActivity({
    required String houseId,
    required String userId,
    required String description,
    required String category,
    String? targetUserId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
