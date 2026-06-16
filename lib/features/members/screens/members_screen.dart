import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/members/models/house_member.dart';
import 'package:nesta/features/members/providers/members_provider.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anggota Rumah'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Gagal memuat anggota')),
        data: (members) => RefreshIndicator(
          onRefresh: () => ref.refresh(membersProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: members.length,
            itemBuilder: (context, index) => _MemberCard(member: members[index]),
          ),
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final HouseMember member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final colors = [AppTheme.primary, AppTheme.warning, AppTheme.success, AppTheme.error, AppTheme.secondary];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: [
          BoxShadow(color: AppTheme.neutral200.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colors[member.name.hashCode % colors.length].withOpacity(0.15),
            backgroundImage: member.avatarUrl != null ? NetworkImage(member.avatarUrl!) : null,
            child: member.avatarUrl == null
                ? Text(
                    member.name[0],
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18,
                        color: colors[member.name.hashCode % colors.length]),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(member.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(width: 8),
                    if (member.role == 'Owner')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text('Owner', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.warning)),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _statBadge(Icons.check_circle_rounded, '${member.tasksCompleted} tugas', AppTheme.success),
                    const SizedBox(width: 12),
                    _statBadge(Icons.warning_amber_rounded, 'Rp${member.totalFines.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}', AppTheme.error),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(member.status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.success)),
          ),
        ],
      ),
    );
  }

  Widget _statBadge(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: AppTheme.neutral500)),
      ],
    );
  }
}
