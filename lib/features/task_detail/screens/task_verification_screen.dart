import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/task_detail/models/task_verification.dart';
import 'package:nesta/features/task_detail/providers/task_verification_provider.dart';

class TaskVerificationScreen extends ConsumerWidget {
  final String taskId;

  const TaskVerificationScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verificationAsync = ref.watch(taskVerificationProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Tugas'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: verificationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat verifikasi')),
        data: (v) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildStatusHeader(context, v),
              const SizedBox(height: 24),
              _buildProgressCard(context, v),
              const SizedBox(height: 24),
              _buildPhotoEvidence(context, v),
              const SizedBox(height: 24),
              _buildSummaryCard(context, v),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Kembali ke Detail'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: const BorderSide(color: AppTheme.neutral300),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context, TaskVerification v) {
    final statusConfig = switch (v.status) {
      VerificationStatus.completed => (
        AppTheme.success,
        Icons.check_circle_rounded,
        'Selesai',
        'Tugas selesai tepat waktu',
        'Tugas ini telah diselesaikan dengan baik dan tepat waktu.',
      ),
      VerificationStatus.late => (
        AppTheme.warning,
        Icons.schedule_rounded,
        'Terlambat',
        'Melewati batas waktu',
        'Tugas diselesaikan tetapi melewati batas waktu yang ditentukan.',
      ),
      VerificationStatus.missed => (
        AppTheme.error,
        Icons.cancel_rounded,
        'Terlewat',
        'Tugas tidak dikerjakan',
        'Tugas ini tidak dikerjakan dan terhitung sebagai pelanggaran.',
      ),
      VerificationStatus.pending => (
        AppTheme.primary,
        Icons.hourglass_empty_rounded,
        'Menunggu',
        'Belum diverifikasi',
        'Tugas menunggu verifikasi dari anggota rumah.',
      ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: statusConfig.$1.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusConfig.$1.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: statusConfig.$1.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(statusConfig.$2, color: statusConfig.$1, size: 36),
          ),
          const SizedBox(height: 16),
          Text(statusConfig.$3,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: statusConfig.$1)),
          const SizedBox(height: 4),
          Text(statusConfig.$4,
              style: const TextStyle(fontSize: 13, color: AppTheme.neutral500)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.cleaning_services_rounded, color: AppTheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(v.roomName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(v.assignedUser,
                          style: const TextStyle(fontSize: 13, color: AppTheme.neutral500)),
                    ],
                  ),
                ),
                Text('${(v.completionPercentage * 100).toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppTheme.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, TaskVerification v) {
    final pct = (v.completionPercentage * 100).toInt();
    final isFull = v.completionPercentage >= 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.assignment_rounded, size: 18, color: AppTheme.primary),
              SizedBox(width: 8),
              Text('Detail Pengerjaan',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: v.completionPercentage,
                      strokeWidth: 6,
                      backgroundColor: AppTheme.neutral200,
                      valueColor: AlwaysStoppedAnimation(
                        isFull ? AppTheme.success : AppTheme.primary,
                      ),
                    ),
                    Text('$pct%', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: isFull ? AppTheme.success : AppTheme.primary)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _progressRow('Selesai', v.completedItems, AppTheme.success),
                    const SizedBox(height: 8),
                    _progressRow('Total', v.totalItems, AppTheme.neutral500),
                    const SizedBox(height: 8),
                    if (v.completedAt != null)
                      _progressRow(
                        'Waktu', 
                        _formatTime(v.completedAt!),
                        AppTheme.neutral500,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressRow(String label, dynamic value, Color color) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.neutral500)),
        const Spacer(),
        Text('$value', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: color)),
      ],
    );
  }

  Widget _buildPhotoEvidence(BuildContext context, TaskVerification v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.image_rounded, size: 18, color: AppTheme.primary),
            SizedBox(width: 8),
            Text('Foto Bukti', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PhotoBox(
                label: 'Sebelum',
                icon: v.beforePhoto != null ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
                color: v.beforePhoto != null ? AppTheme.success : AppTheme.neutral400,
                subtitle: v.beforePhoto != null ? 'Tersedia' : 'Tidak ada',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PhotoBox(
                label: 'Sesudah',
                icon: v.afterPhoto != null ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
                color: v.afterPhoto != null ? AppTheme.success : AppTheme.neutral400,
                subtitle: v.afterPhoto != null ? 'Tersedia' : 'Tidak ada',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, TaskVerification v) {
    final monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.summarize_rounded, size: 18, color: AppTheme.primary),
              SizedBox(width: 8),
              Text('Ringkasan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          _summaryRow('Tanggal Tugas', '${v.assignedDate.day} ${monthNames[v.assignedDate.month]} ${v.assignedDate.year}'),
          const SizedBox(height: 10),
          _summaryRow('Ditugaskan Kepada', v.assignedUser),
          const SizedBox(height: 10),
          _summaryRow('Ruangan', v.roomName),
          if (v.completedAt != null) ...[
            const SizedBox(height: 10),
            _summaryRow('Selesai Pada', '${v.completedAt!.day} ${monthNames[v.completedAt!.month]} ${v.completedAt!.year}, ${v.completedAt!.hour.toString().padLeft(2, '0')}:${v.completedAt!.minute.toString().padLeft(2, '0')}'),
          ],
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          _summaryRow('Status', v.status.name.toUpperCase(),
              valueColor: switch (v.status) {
                VerificationStatus.completed => AppTheme.success,
                VerificationStatus.late => AppTheme.warning,
                VerificationStatus.missed => AppTheme.error,
                VerificationStatus.pending => AppTheme.primary,
              }),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.neutral500)),
        Text(value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: valueColor ?? AppTheme.neutral800,
            )),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} WIB';
  }
}

class _PhotoBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _PhotoBox({
    required this.label,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.neutral50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.neutral600)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.neutral400)),
        ],
      ),
    );
  }
}
