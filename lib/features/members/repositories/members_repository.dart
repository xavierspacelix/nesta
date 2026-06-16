import 'package:nesta/features/settings/models/user_profile.dart';
import '../models/house_member.dart';

abstract class IMembersRepository {
  Future<List<HouseMember>> getMembers();
  Future<UserProfile?> getCurrentProfile();
  Future<void> updateAvatar(String avatarUrl);
}

class MockMembersRepository implements IMembersRepository {
  @override
  Future<List<HouseMember>> getMembers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      HouseMember(name: 'Budi', role: 'Owner', tasksCompleted: 22, totalFines: 0, status: 'Aktif', avatarUrl: null),
      HouseMember(name: 'Juan', role: 'Member', tasksCompleted: 18, totalFines: 25000, status: 'Aktif'),
      HouseMember(name: 'Rizki', role: 'Member', tasksCompleted: 14, totalFines: 50000, status: 'Aktif'),
      HouseMember(name: 'Dika', role: 'Member', tasksCompleted: 9, totalFines: 75000, status: 'Aktif'),
      HouseMember(name: 'Fajar', role: 'Member', tasksCompleted: 20, totalFines: 12500, status: 'Aktif'),
    ];
  }

  @override
  Future<UserProfile?> getCurrentProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const UserProfile(
      name: 'Budi',
      email: 'budi@email.com',
      role: 'Owner',
      roomName: 'Kamar Utama',
      createdAt: null,
      tasksCompleted: 22,
      totalFines: 0,
    );
  }

  @override
  Future<void> updateAvatar(String avatarUrl) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
