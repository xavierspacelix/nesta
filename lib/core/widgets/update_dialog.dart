import 'package:flutter/material.dart';
import 'package:nesta/app/theme/app_theme.dart';
import '../models/app_version.dart';
import '../services/download_service.dart';

class UpdateDialog extends StatefulWidget {
  final AppVersion version;
  final bool isForce;

  const UpdateDialog({
    super.key,
    required this.version,
    required this.isForce,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final _service = DownloadService();
  bool _isDownloading = false;
  bool _isReady = false;
  double _progress = 0;
  String? _apkPath;
  String? _error;

  Future<void> _downloadAndInstall() async {
    setState(() {
      _isDownloading = true;
      _progress = 0;
      _error = null;
    });

    try {
      _apkPath = await _service.downloadApk(
        widget.version.apkUrl,
        onProgress: (received, total) {
          if (total > 0) {
            setState(() => _progress = received / total);
          }
        },
      );
      setState(() => _isReady = true);
      await _service.installApk(_apkPath!);
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _isReady = false;
        _error = 'Gagal membuka penginstal. Aktifkan "Instal dari sumber tidak dikenal" di pengaturan, lalu coba lagi.';
      });
    }
  }

  Future<void> _openSettings() async {
    await DownloadService.openInstallSettings();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isForce,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(
              Icons.system_update_rounded,
              color: widget.isForce ? AppTheme.error : AppTheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('Pembaruan Tersedia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Versi ${widget.version.version}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            if (widget.isForce) ...[
              const SizedBox(height: 8),
              const Text(
                'Pembaruan ini wajib diinstal untuk melanjutkan penggunaan.',
                style: TextStyle(color: AppTheme.error, fontSize: 13),
              ),
            ],
            if (widget.version.changelog.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Perubahan:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.neutral50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.version.changelog
                      .split('\n')
                      .where((l) => l.trim().isNotEmpty)
                      .map((line) {
                    final clean = line.replaceAll(RegExp(r'^#{1,3}\s*'), '')
                        .replaceAll(RegExp(r'^\*\*\s*'), '')
                        .trimLeft();
                    final isSection = line.startsWith('##');
                    final isItem = line.trimLeft().startsWith('- ');
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4, left: isItem ? 12 : 0),
                      child: Text(
                        isItem ? clean.replaceFirst('- ', '• ') : clean,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSection ? FontWeight.w700 : FontWeight.w400,
                          color: isSection ? AppTheme.neutral800 : AppTheme.neutral600,
                          height: 1.4,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            if (_isDownloading && !_isReady) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppTheme.neutral200,
                valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                borderRadius: BorderRadius.circular(100),
                minHeight: 6,
              ),
              const SizedBox(height: 8),
              Text(
                '${(_progress * 100).toInt()}% — Mengunduh...',
                style: const TextStyle(fontSize: 12, color: AppTheme.neutral500),
              ),
            ],
            if (_isReady) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.warning),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Izinkan instalasi dari sumber tidak dikenal di pengaturan untuk melanjutkan.',
                        style: TextStyle(fontSize: 12, color: AppTheme.neutral700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _error!,
                      style: const TextStyle(fontSize: 12, color: AppTheme.error),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _openSettings,
                      icon: const Icon(Icons.settings_rounded, size: 16),
                      label: const Text('Buka Pengaturan', style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!widget.isForce && !_isDownloading && _error == null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Nanti Saja'),
            ),
          if (!_isDownloading && _error == null)
            ElevatedButton(
              onPressed: _downloadAndInstall,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isForce ? AppTheme.error : AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Perbarui Sekarang'),
            ),
          if (_isReady || _error != null)
            ElevatedButton.icon(
              onPressed: _isReady ? () => _service.installApk(_apkPath!) : _openSettings,
              icon: Icon(_isReady ? Icons.file_open_rounded : Icons.settings_rounded, size: 18),
              label: Text(_isReady ? 'Buka Penginstal' : 'Buka Pengaturan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
        ],
      ),
    );
  }
}
