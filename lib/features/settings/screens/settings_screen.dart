import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/models/notification_type.dart';
import 'package:nesta/core/providers/notification_provider.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(notificationEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Akun'),
          const SizedBox(height: 8),
          _buildMenuTile('Profil', Icons.person_outline_rounded, onTap: () => context.push('/settings/profile')),
          _buildMenuTile('Rumah', Icons.home_outlined, onTap: () => context.push('/settings/house')),
          const SizedBox(height: 24),
          _buildNotificationSection(enabled, () {
            ref.read(notificationEnabledProvider.notifier).toggle();
          }),
          const SizedBox(height: 32),
          _buildSectionHeader('Tentang'),
          const SizedBox(height: 8),
          _buildMenuTile('Versi 1.0.0', Icons.info_outline_rounded),
          const SizedBox(height: 32),
          _buildLogoutButton(context, ref),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: AppTheme.neutral500,
      ),
    );
  }

  Widget _buildMenuTile(String title, IconData icon, {VoidCallback? onTap}) {
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
              Icon(icon, size: 20, color: AppTheme.neutral500),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 14)),
              const Spacer(),
              const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.neutral300),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(authProvider.notifier).logout();
        context.go('/welcome');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 18, color: AppTheme.error),
            SizedBox(width: 8),
            Text(
              'Keluar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(bool enabled, VoidCallback onToggle) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.notifications_outlined, size: 20, color: AppTheme.neutral500),
                const SizedBox(width: 12),
                const Text('Notifikasi', style: TextStyle(fontSize: 14)),
                const Spacer(),
                Switch(
                  value: enabled,
                  onChanged: (_) => onToggle(),
                  activeColor: AppTheme.primary,
                ),
              ],
            ),
          ),
          if (enabled) _notificationList,
        ],
      ),
    );
  }

  Widget get _notificationList => Padding(
    padding: const EdgeInsets.fromLTRB(48, 0, 16, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final type in NotificationType.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• ${type.label} — ${type.description}',
                style: const TextStyle(fontSize: 12, color: AppTheme.neutral400, height: 1.4)),
          ),
      ],
    ),
  );

}
