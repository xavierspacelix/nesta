class UserProfile {
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final String status;
  final String? roomName;
  final DateTime? createdAt;
  final int tasksCompleted;
  final int totalFines;

  const UserProfile({
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    this.status = 'Aktif',
    this.roomName,
    this.createdAt,
    this.tasksCompleted = 0,
    this.totalFines = 0,
  });
}
