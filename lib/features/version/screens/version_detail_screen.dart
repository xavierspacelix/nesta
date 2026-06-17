import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/update_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionDetailScreen extends ConsumerStatefulWidget {
  const VersionDetailScreen({super.key});

  @override
  ConsumerState<VersionDetailScreen> createState() => _VersionDetailScreenState();
}

class _VersionDetailScreenState extends ConsumerState<VersionDetailScreen> {
  String _currentVersion = 'Memuat...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _currentVersion = '${info.version}+${info.buildNumber}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final latestAsync = ref.watch(updateCheckProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Versi'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.neutral50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.home_rounded, size: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text('Nesta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    'Versi $_currentVersion',
                    style: const TextStyle(fontSize: 14, color: AppTheme.neutral500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Riwayat Pembaruan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            latestAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.neutral50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Tidak ada riwayat pembaruan.', style: TextStyle(color: AppTheme.neutral500)),
              ),
              data: (result) {
                if (result.version == null) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.neutral50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Tidak ada riwayat pembaruan.', style: TextStyle(color: AppTheme.neutral500)),
                  );
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.neutral50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'v${result.version!.version}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Terbaru', style: TextStyle(fontSize: 12, color: AppTheme.neutral500)),
                        ],
                      ),
                      if (result.version!.changelog.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          result.version!.changelog,
                          style: const TextStyle(fontSize: 13, color: AppTheme.neutral600, height: 1.5),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
