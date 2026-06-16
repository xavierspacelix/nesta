import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/storage_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/core/utils/image_picker_helper.dart';
import 'package:nesta/features/finance/models/electricity_purchase.dart';
import 'package:nesta/features/finance/providers/electricity_provider.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';

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
          onRefresh: () => ref.refresh(electricityPurchasesProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...purchases.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PurchaseCard(purchase: p),
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
                : () {
                    final amount = int.tryParse(_amountController.text.trim());
                    if (amount != null && amount > 0) {
                      ref
                          .read(electricityRepositoryProvider)
                          .addPurchase(amount, currentUser, _proofPhoto);
                      ref.invalidate(electricityPurchasesProvider);
                      _amountController.clear();
                      setState(() {
                        _showForm = false;
                        _proofPhoto = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pembelian listrik dicatat'),
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

  const _PurchaseCard({required this.purchase});

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

    return Container(
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
                      const Icon(
                        Icons.image_rounded,
                        size: 12,
                        color: AppTheme.primary,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            'Rp${purchase.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppTheme.warning,
            ),
          ),
        ],
      ),
    );
  }
}
