import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/finance/providers/rent_provider.dart';
import 'package:nesta/features/finance/providers/water_provider.dart';
import 'package:nesta/features/finance/providers/finance_provider.dart';
import 'package:nesta/features/finance/models/rent_record.dart';
import 'package:nesta/features/finance/models/monthly_expenses.dart';

class FinancialDashboardScreen extends ConsumerWidget {
  const FinancialDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentAsync = ref.watch(rentHistoryProvider);
    final waterAsync = ref.watch(waterScheduleProvider);
    final selectedDate = ref.watch(selectedMonthProvider);
    final expensesAsync = ref.watch(monthlyExpensesProvider(selectedDate));
    final houseCreatedAtAsync = ref.watch(houseCreatedAtProvider);

    final monthNames = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(rentHistoryProvider);
            await ref.read(rentHistoryProvider.future);
            ref.invalidate(waterScheduleProvider);
            await ref.read(waterScheduleProvider.future);
            ref.invalidate(monthlyExpensesProvider(selectedDate));
            await ref.read(monthlyExpensesProvider(selectedDate).future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Keuangan',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _MonthSelector(
                  selectedDate: selectedDate,
                  minDate: houseCreatedAtAsync.valueOrNull,
                  onPrevious: () {
                    final prev = DateTime(selectedDate.year, selectedDate.month - 1);
                    ref.read(selectedMonthProvider.notifier).state = prev;
                  },
                  onNext: () {
                    final next = DateTime(selectedDate.year, selectedDate.month + 1);
                    ref.read(selectedMonthProvider.notifier).state = next;
                  },
                  canGoNext: selectedDate.month < DateTime.now().month ||
                      selectedDate.year < DateTime.now().year,
                ),
                const SizedBox(height: 20),
                _buildRentTile(context, rentAsync, selectedDate, monthNames),
                const SizedBox(height: 12),
                _CategoryCard(
                  icon: Icons.warning_amber_rounded,
                  label: 'Denda',
                  subtitle: expensesAsync.valueOrNull != null
                      ? 'Rp${_formatAmount(expensesAsync.valueOrNull!.fines)}'
                      : 'Memuat...',
                  color: AppTheme.error,
                  trailing: '',
                  onTap: () => context.push('/finance/fines'),
                ),
                const SizedBox(height: 12),
                _CategoryCard(
                  icon: Icons.bolt_rounded,
                  label: 'Listrik',
                  subtitle: expensesAsync.valueOrNull != null
                      ? 'Rp${_formatAmount(expensesAsync.valueOrNull!.electricity)}'
                      : 'Memuat...',
                  color: AppTheme.warning,
                  trailing: '',
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
                  trailing: '',
                  onTap: () => context.push('/finance/water'),
                ),
                const SizedBox(height: 24),
                expensesAsync.when(
                  loading: () => const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (data) {
                    if (data == null || data.total == 0) return const SizedBox.shrink();
                    return _ExpenseAnalytics(expenses: data);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRentTile(
    BuildContext context,
    AsyncValue<List<RentRecord>> rentAsync,
    DateTime selectedDate,
    List<String> monthNames,
  ) {
    String trailing = '-';
    if (rentAsync.valueOrNull != null) {
      final match = rentAsync.valueOrNull!.where(
        (r) => r.year == selectedDate.year && r.month == selectedDate.month,
      );
      if (match.isNotEmpty) {
        final record = match.first;
        trailing = '${record.paidCount}/${record.totalCount}';
      }
    }

    return _CategoryCard(
      icon: Icons.home_work_rounded,
      label: 'Sewa + WiFi',
      subtitle: '${monthNames[selectedDate.month]} ${selectedDate.year}',
      color: AppTheme.primary,
      trailing: trailing,
      onTap: () => context.push('/finance/rent'),
    );
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}

class _MonthSelector extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime? minDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoNext;

  const _MonthSelector({
    required this.selectedDate,
    this.minDate,
    required this.onPrevious,
    required this.onNext,
    required this.canGoNext,
  });

  bool get _canGoPrevious {
    if (minDate == null) return true;
    final prev = DateTime(selectedDate.year, selectedDate.month - 1);
    return prev.year > minDate!.year ||
        (prev.year == minDate!.year && prev.month >= minDate!.month);
  }

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final isCurrentMonth = selectedDate.month == DateTime.now().month &&
        selectedDate.year == DateTime.now().year;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _canGoPrevious ? onPrevious : null,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.neutral100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                size: 20,
                color: _canGoPrevious ? AppTheme.neutral600 : AppTheme.neutral300,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                '${monthNames[selectedDate.month]} ${selectedDate.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              if (isCurrentMonth)
                const Text(
                  'Bulan ini',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.neutral500,
                  ),
                ),
            ],
          ),
          GestureDetector(
            onTap: canGoNext ? onNext : null,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: canGoNext ? AppTheme.neutral100 : AppTheme.neutral100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: canGoNext ? AppTheme.neutral600 : AppTheme.neutral300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseAnalytics extends StatelessWidget {
  final MonthlyExpenses expenses;

  const _ExpenseAnalytics({required this.expenses});

  String _format(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral200.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Ringkasan Pengeluaran',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _expenseRow(
            'Sewa Kamar',
            expenses.rent,
            AppTheme.primary,
          ),
          if (expenses.wifi > 0) ...[
            const SizedBox(height: 8),
            _expenseRow('WiFi', expenses.wifi, AppTheme.primaryDark),
          ],
          if (expenses.electricity > 0) ...[
            const SizedBox(height: 8),
            _expenseRow('Listrik', expenses.electricity, AppTheme.warning),
          ],
          if (expenses.waterCount > 0) ...[
            const SizedBox(height: 8),
            _expenseRow('Air (${expenses.waterCount}x)', 0, AppTheme.secondary),
          ],
          if (expenses.fines > 0) ...[
            const SizedBox(height: 8),
            _expenseRow('Denda', expenses.fines, AppTheme.error),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Text(
                'Rp${_format(expenses.total)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _expenseRow(String label, int amount, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.neutral600,
            ),
          ),
        ),
        if (amount > 0)
          Text(
            'Rp${_format(amount)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
      ],
    );
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
            BoxShadow(
              color: AppTheme.neutral200.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
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
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              trailing,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.neutral400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
