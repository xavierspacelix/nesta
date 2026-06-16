import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/storage_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/core/utils/image_picker_helper.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';
import 'package:nesta/features/members/providers/members_provider.dart';
import 'package:nesta/features/settings/models/user_profile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final profileAsync = ref.watch(currentProfileProvider);

    final name = authState.userName ?? 'User';
    final email = authState.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildProfileBody(context, ref, name, email, null),
        data: (profile) => _buildProfileBody(context, ref, name, email, profile),
      ),
    );
  }

  Widget _buildProfileBody(
    BuildContext context,
    WidgetRef ref,
    String name,
    String email,
    UserProfile? profile,
  ) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final avatarUrl = profile?.avatarUrl;
    final role = profile?.role ?? 'Member';
    final createdAt = profile?.createdAt;
    final joinDate = createdAt != null
        ? '${createdAt.day} ${_monthName(createdAt.month)} ${createdAt.year}'
        : '-';
    final tasksDone = profile?.tasksCompleted ?? 0;
    final totalFines = profile?.totalFines ?? 0;
    final roomName = profile?.roomName;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _pickAvatar(context, ref),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppTheme.primary.withOpacity(0.15),
                      backgroundImage: avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl == null
                          ? Text(
                              initial,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                                color: AppTheme.primary,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.neutral500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        if (roomName != null)
          _buildInfoTile('Kamar', roomName, Icons.bed_rounded),
        _buildInfoTile('Bergabung', joinDate, Icons.calendar_month_rounded),
        _buildInfoTile('Role', role, Icons.shield_rounded),
        const SizedBox(height: 32),
        _buildSectionTitle('Ringkasan Bulan Ini'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '$tasksDone',
                'Tugas Selesai',
                AppTheme.success,
                Icons.check_circle_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '$totalFines',
                'Denda',
                AppTheme.error,
                Icons.warning_amber_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _pickAvatar(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.neutral300, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              const Text('Foto Profil', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _pickAndUpload(ref, ImagePickerHelper.pickFromCamera);
                  },
                  icon: const Icon(Icons.camera_alt_rounded, size: 20),
                  label: const Text('Kamera', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _pickAndUpload(ref, ImagePickerHelper.pickFromGallery);
                  },
                  icon: const Icon(Icons.photo_library_rounded, size: 20),
                  label: const Text('Galeri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUpload(
    WidgetRef ref,
    Future<({List<int> bytes, String fileName})?> Function() picker,
  ) async {
    final picked = await picker();
    if (picked == null) return;
    _uploadAvatar(ref, picked.bytes, picked.fileName);
  }

  Future<void> _uploadAvatar(WidgetRef ref, List<int> bytes, String fileName) async {
    try {
      final storage = ref.read(storageServiceProvider);
      final url = await storage.uploadFile(
        folder: 'avatars',
        fileName: fileName,
        bytes: bytes,
      );
      final repo = ref.read(membersRepositoryProvider);
      await repo.updateAvatar(url);
      ref.invalidate(currentProfileProvider);
    } catch (e) {
      Log.e('AvatarUpload', 'failed', e);
    }
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.neutral50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.neutral500),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.neutral400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: AppTheme.neutral500,
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.neutral500),
          ),
        ],
      ),
    );
  }
}

const _monthNames = [
  '',
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

String _monthName(int month) => _monthNames[month];
