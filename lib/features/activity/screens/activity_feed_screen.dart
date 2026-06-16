import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/activity/models/feed_item.dart';
import 'package:nesta/features/activity/providers/activity_provider.dart';

class ActivityFeedScreen extends ConsumerWidget {
  const ActivityFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(activityFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivitas'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: feedAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const Center(child: Text('Gagal memuat aktivitas')),
          data: (items) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(activityFeedProvider);
              await ref.read(activityFeedProvider.future);
            },
            color: AppTheme.primary,
            child: _buildTimeline(context, items),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, List<FeedItem> items) {
    final grouped = _groupByDate(items);

    if (grouped.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none_rounded, size: 64, color: AppTheme.neutral300),
            const SizedBox(height: 16),
            const Text('Belum ada aktivitas', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('Aktivitas rumah akan muncul di sini',
                style: TextStyle(fontSize: 13, color: AppTheme.neutral500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      itemCount: grouped.length,
      itemBuilder: (context, sectionIndex) {
        final section = grouped[sectionIndex];
        return _buildSection(context, section.$1, section.$2, sectionIndex == 0);
      },
    );
  }

  Widget _buildSection(BuildContext context, String label, List<FeedItem> items, bool isFirst) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isFirst) const SizedBox(height: 24),
        Row(
          children: [
            Container(
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _FeedTile(item: item),
        )),
      ],
    );
  }

  List<(String, List<FeedItem>)> _groupByDate(List<FeedItem> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));

    final todayItems = <FeedItem>[];
    final yesterdayItems = <FeedItem>[];
    final weekItems = <FeedItem>[];
    final olderItems = <FeedItem>[];

    for (final item in items) {
      final local = item.timestamp.toLocal();
      final itemDate = DateTime(local.year, local.month, local.day);
      if (itemDate == today) {
        todayItems.add(item);
      } else if (itemDate == yesterday) {
        yesterdayItems.add(item);
      } else if (itemDate.isAfter(thisWeekStart.subtract(const Duration(days: 1)))) {
        weekItems.add(item);
      } else {
        olderItems.add(item);
      }
    }

    final result = <(String, List<FeedItem>)>[];
    if (todayItems.isNotEmpty) result.add(('Hari Ini', todayItems));
    if (yesterdayItems.isNotEmpty) result.add(('Kemarin', yesterdayItems));
    if (weekItems.isNotEmpty) result.add(('Minggu Ini', weekItems));
    if (olderItems.isNotEmpty) result.add(('Lebih Lama', olderItems));
    return result;
  }
}

class _FeedTile extends StatelessWidget {
  final FeedItem item;

  const _FeedTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final config = switch (item.category) {
      FeedCategory.chore => (Icons.cleaning_services_rounded, AppTheme.success, 'task selesai'),
      FeedCategory.photo => (Icons.camera_alt_rounded, AppTheme.secondary, 'foto diunggah'),
      FeedCategory.swap => (Icons.swap_horiz_rounded, AppTheme.primary, 'tukar jadwal'),
      FeedCategory.fine => (Icons.receipt_rounded, AppTheme.warning, 'transaksi'),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: config.$2.withOpacity(0.12),
          child: Text(
            item.userInitial,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: config.$2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: AppTheme.neutral800, height: 1.3),
                  children: [
                    TextSpan(
                      text: item.userName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: ' ${item.description}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(config.$1, size: 11, color: config.$2),
                  const SizedBox(width: 4),
                  Text(
                    item.timeAgo,
                    style: const TextStyle(fontSize: 11, color: AppTheme.neutral400),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
