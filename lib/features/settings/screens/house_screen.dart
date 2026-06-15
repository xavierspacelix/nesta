import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/house/providers/house_provider.dart';
import 'package:nesta/features/members/providers/members_provider.dart';

class HouseScreen extends ConsumerWidget {
  const HouseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final houseAsync = ref.watch(houseProvider);
    final membersAsync = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rumah'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: houseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Gagal memuat data rumah')),
        data: (house) {
          if (house == null) {
            return const Center(
              child: Text('Belum tergabung ke rumah mana pun'),
            );
          }

          final memberCount = membersAsync.valueOrNull?.length ?? 0;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    color: AppTheme.primary,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  house.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoTile(
                'Kode Undangan',
                house.inviteCode.toUpperCase(),
                Icons.key_rounded,
                onCopy: () {
                  Clipboard.setData(ClipboardData(text: house.inviteCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kode undangan disalin!')),
                  );
                },
              ),
              _buildInfoTile(
                'Anggota',
                '$memberCount orang',
                Icons.people_rounded,
              ),
              _buildInfoTile(
                'Dibuat',
                _formatDate(house.createdAt),
                Icons.calendar_month_rounded,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Pengaturan'),
              const SizedBox(height: 12),
              _buildActionTile(
                'Kelola Rumah',
                Icons.tune_rounded,
                onTap: () => context.push('/settings/house/manage'),
              ),
              _buildActionTile('Ganti Nama Rumah', Icons.edit_outlined),
              _buildActionTile(
                'Atur Ulang Kode Undangan',
                Icons.refresh_rounded,
              ),
              _buildActionTile(
                'Keluar dari Rumah',
                Icons.logout_rounded,
                isDestructive: true,
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  Widget _buildInfoTile(
    String label,
    String value,
    IconData icon, {
    VoidCallback? onCopy,
  }) {
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
            if (onCopy != null)
              GestureDetector(
                onTap: onCopy,
                child: const Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: AppTheme.neutral300,
                ),
              ),
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

  Widget _buildActionTile(
    String title,
    IconData icon, {
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppTheme.error : AppTheme.neutral700;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.neutral50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Text(title, style: TextStyle(fontSize: 14, color: color)),
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppTheme.neutral300,
              ),
            ],
          ),
        ),
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
