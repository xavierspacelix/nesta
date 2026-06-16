import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/storage_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/core/utils/image_picker_helper.dart';
import 'package:nesta/features/activity/providers/activity_provider.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';
import 'package:nesta/features/finance/models/electricity_purchase.dart';
import 'package:nesta/features/finance/providers/electricity_provider.dart';
import 'package:nesta/features/members/providers/members_provider.dart';
import 'package:nesta/core/widgets/auth_image.dart';

class ElectricityScreen extends ConsumerStatefulWidget {
  const ElectricityScreen({super.key});

  @override
  ConsumerState<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends ConsumerState<ElectricityScreen> {
  final _amountController = TextEditingController();
  bool _showForm = false;
  String? _proofPhoto;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purchasesAsync = ref.watch(electricityPurchasesProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listrik'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: purchasesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Gagal memuat data')),
        data: (purchases) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(electricityPurchasesProvider);
            await ref.read(electricityPurchasesProvider.future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...purchases.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PurchaseCard(
                      purchase: p,
                      onTap: () => _showDetailSheet(context, ref, p),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_showForm) _buildForm(currentUser),
                if (!_showForm)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _showForm = true),
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text(
                        'Tambah Pembelian',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailSheet(
    BuildContext context,
    WidgetRef ref,
    ElectricityPurchase purchase,
  ) {
    final profile = ref.read(currentProfileProvider).valueOrNull;
    final isAdmin = profile?.role == 'Owner';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: AppTheme.warning,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rp${purchase.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Dibeli oleh ${purchase.purchasedBy}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.neutral500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _statusBadge(purchase),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow('Tanggal',
                '${purchase.date.day}/${purchase.date.month}/${purchase.date.year}'),
            const SizedBox(height: 20),
            if (purchase.isVerified) ...[
              if (purchase.proofPhoto != null)
                _buildProofPreview(purchase),
              const SizedBox(height: 12),
              _buildVerifiedCard(),
            ] else if (purchase.proofPhoto != null && isAdmin)
              _buildAdminVerifySection(context, ref, purchase)
            else if (purchase.proofPhoto != null)
              _buildProofPreview(purchase),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(ElectricityPurchase purchase) {
    final isPending = !purchase.isVerified && purchase.proofPhoto != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (purchase.isVerified
                ? AppTheme.success
                : isPending
                    ? AppTheme.warning
                    : AppTheme.neutral400)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        purchase.isVerified
            ? 'Terverifikasi'
            : isPending
                ? 'Menunggu'
                : 'Belum',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: purchase.isVerified
              ? AppTheme.success
              : isPending
                  ? AppTheme.warning
                  : AppTheme.neutral500,
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.neutral500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  Widget _buildVerifiedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, size: 20, color: AppTheme.success),
          SizedBox(width: 8),
          Text(
            'Terverifikasi',
            style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.success),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminVerifySection(
    BuildContext context,
    WidgetRef ref,
    ElectricityPurchase purchase,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showProofFullScreen(context, purchase.proofPhoto!),
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.neutral200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AuthImage(
                imageUrl: purchase.proofPhoto!,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () async {
              try {
                await ref.read(electricityRepositoryProvider).verifyPurchase(purchase.id);
                ref.invalidate(electricityPurchasesProvider);
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pembelian diverifikasi')),
                );
              } catch (e) {
                Log.e('ElectricityVerify', 'failed', e);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal memverifikasi')),
                );
              }
            },
            icon: const Icon(Icons.verified_rounded, size: 20),
            label: const Text(
              'Verifikasi Pembelian',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProofPreview(ElectricityPurchase purchase) {
    return GestureDetector(
      onTap: () => _showProofFullScreen(context, purchase.proofPhoto!),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.neutral200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AuthImage(
            imageUrl: purchase.proofPhoto!,
            width: double.infinity,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showProofFullScreen(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => GestureDetector(
        onTap: () => Navigator.pop(ctx),
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text('Bukti Pembelian'),
          ),
          body: Center(
            child: InteractiveViewer(
              child: AuthImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(String currentUser) {
    return Column(
      children: [
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Nominal (Rp)',
            hintStyle: const TextStyle(
              color: AppTheme.neutral400,
              fontSize: 14,
            ),
            prefixText: 'Rp ',
            prefixStyle: const TextStyle(
              color: AppTheme.neutral600,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: AppTheme.neutral50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.neutral50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.neutral200,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: AppTheme.neutral400,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _proofPhoto != null
                    ? 'Foto terupload'
                    : 'Foto bukti (opsional)',
                style: TextStyle(
                  fontSize: 13,
                  color: _proofPhoto != null
                      ? AppTheme.success
                      : AppTheme.neutral500,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final picked = await ImagePickerHelper.pickFromGallery();
                  if (picked == null) return;
                  try {
                    final storage = ref.read(storageServiceProvider);
                    final url = await storage.uploadFile(
                      folder: 'electricity-proof',
                      fileName: picked.fileName,
                      bytes: picked.bytes,
                    );
                    if (!mounted) return;
                    setState(() => _proofPhoto = url);
                  } catch (e) {
                    Log.e('ElectricityUpload', 'failed', e);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (_proofPhoto != null
                                ? AppTheme.success
                                : AppTheme.primary)
                            .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    _proofPhoto != null ? 'Ganti' : 'Upload',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _proofPhoto != null
                          ? AppTheme.success
                          : AppTheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _amountController.text.trim().isEmpty
                ? null
                : () async {
                    final amount = int.tryParse(_amountController.text.trim());
                    if (amount == null || amount <= 0) return;
                    try {
                      await ref
                          .read(electricityRepositoryProvider)
                          .addPurchase(amount, currentUser, _proofPhoto);
                      final authState = ref.read(authProvider);
                      final activityRepo = ref.read(activityRepositoryProvider);
                      if (authState.houseId != null) {
                        await activityRepo.createActivity(
                          houseId: authState.houseId!,
                          userId: authState.userId ?? '',
                          description: 'membeli listrik',
                          category: 'fine',
                        );
                      }
                      ref.invalidate(electricityPurchasesProvider);
                      _amountController.clear();
                      setState(() {
                        _showForm = false;
                        _proofPhoto = null;
                      });
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pembelian listrik dicatat'),
                        ),
                      );
                    } catch (e) {
                      Log.e('Electricity', 'addPurchase failed', e);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal menyimpan pembelian'),
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _PurchaseCard extends StatelessWidget {
  final ElectricityPurchase purchase;
  final VoidCallback onTap;

  const _PurchaseCard({required this.purchase, required this.onTap});

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
    final date = purchase.date;
    final isPending = !purchase.isVerified && purchase.proofPhoto != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.neutral200),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  monthNames[date.month],
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.neutral500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(width: 1, height: 36, color: AppTheme.neutral200),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 7,
                        backgroundColor: AppTheme.primary.withOpacity(0.15),
                        child: Text(
                          purchase.purchasedBy[0],
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        purchase.purchasedBy,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (purchase.proofPhoto != null) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.image_rounded,
                          size: 12,
                          color: isPending
                              ? AppTheme.warning
                              : AppTheme.primary,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp${purchase.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.warning,
                  ),
                ),
                if (isPending)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      'Menunggu',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.warning),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
