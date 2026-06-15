import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/finance/providers/fine_provider.dart';
import 'package:nesta/features/finance/providers/rent_provider.dart';
import 'package:nesta/features/finance/providers/electricity_provider.dart';
import 'package:nesta/features/finance/providers/water_provider.dart';

class FinancialDashboardScreen extends ConsumerWidget {
  const FinancialDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finesAsync = ref.watch(currentFinesProvider);
    final rentAsync = ref.watch(rentHistoryProvider);
    final electricityAsync = ref.watch(electricityPurchasesProvider);
    final waterAsync = ref.watch(waterScheduleProvider);

    final monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Keuangan', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('${monthNames[now.month]} ${now.year}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.neutral500)),
              const SizedBox(height: 20),
              _CategoryCard(
                icon: Icons.warning_amber_rounded,
                label: 'Denda',
                subtitle: 'Belum Dibayar',
                color: AppTheme.error,
                trailing: finesAsync.valueOrNull?.length.toString() ?? '0',
                onTap: () => context.push('/finance/fines'),
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                icon: Icons.home_work_rounded,
                label: 'Sewa + WiFi',
                subtitle: '${monthNames[now.month]} ${now.year}',
                color: AppTheme.primary,
                trailing: rentAsync.valueOrNull?.isNotEmpty == true
                    ? '${rentAsync.valueOrNull!.first.paidCount}/${rentAsync.valueOrNull!.first.totalCount}'
                    : '-',
                onTap: () => context.push('/finance/rent'),
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                icon: Icons.bolt_rounded,
                label: 'Listrik',
                subtitle: '${electricityAsync.valueOrNull?.length ?? 0}x pembelian',
                color: AppTheme.warning,
                trailing: electricityAsync.valueOrNull?.isNotEmpty == true
                    ? 'Rp${(_formatAmount(electricityAsync.valueOrNull!.last.amount))}'
                    : '-',
                onTap: () => context.push('/finance/electricity'),
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                icon: Icons.water_drop_rounded,
                label: 'Galon Air',
                subtitle: waterAsync.valueOrNull != null
                    ? 'Giliran: ${waterAsync.valueOrNull!.nextBuyer}'
                    : 'Memuat...',
                color: AppTheme.secondary,
                trailing: '${waterAsync.valueOrNull?.daysSinceLastPurchase ?? 0} hari',
                onTap: () => context.push('/finance/water'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    final s = amount.toString();
    return s.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final String trailing;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.neutral500)),
                ],
              ),
            ),
            Text(trailing, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: color)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.neutral400, size: 20),
          ],
        ),
      ),
    );
  }
}
