class HouseMember {
  final String name;
  final String role;
  final int tasksCompleted;
  final int totalFines;
  final String status;
  final String? avatarUrl;

  const HouseMember({
    required this.name,
    required this.role,
    required this.tasksCompleted,
    required this.totalFines,
    required this.status,
    this.avatarUrl,
  });
}
