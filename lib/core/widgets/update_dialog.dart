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
  double _progress = 0;

  Future<void> _downloadAndInstall() async {
    setState(() {
      _isDownloading = true;
      _progress = 0;
    });

    try {
      final path = await _service.downloadApk(
        widget.version.apkUrl,
        onProgress: (received, total) {
          if (total > 0) {
            setState(() => _progress = received / total);
          }
        },
      );
      await _service.installApk(path);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengunduh pembaruan. Silakan coba lagi.')),
        );
      }
    }
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
              Text(
                widget.version.changelog,
                style: const TextStyle(fontSize: 13, color: AppTheme.neutral600),
              ),
            ],
            if (_isDownloading) ...[
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
          ],
        ),
        actions: [
          if (!widget.isForce && !_isDownloading)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Nanti Saja'),
            ),
          if (!_isDownloading)
            ElevatedButton(
              onPressed: _downloadAndInstall,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isForce ? AppTheme.error : AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Perbarui Sekarang'),
            ),
        ],
      ),
    );
  }
}
