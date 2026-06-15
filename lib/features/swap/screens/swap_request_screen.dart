import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/models/notification_type.dart';
import 'package:nesta/core/providers/notification_provider.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';
import 'package:nesta/features/swap/providers/swap_provider.dart';

class SwapRequestScreen extends ConsumerStatefulWidget {
  const SwapRequestScreen({super.key});

  @override
  ConsumerState<SwapRequestScreen> createState() => _SwapRequestScreenState();
}

class _SwapRequestScreenState extends ConsumerState<SwapRequestScreen> {
  String? _selectedMember;
  DateTime? _selectedDate;
  final _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(membersProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tukar Jadwal'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Anggota', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            membersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Text('Gagal memuat anggota'),
              data: (members) => _MemberSelector(
                members: members.where((m) => m != currentUser).toList(),
                selected: _selectedMember,
                onSelected: (m) => setState(() => _selectedMember = m),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Pilih Tanggal', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            _DatePickerTile(
              selectedDate: _selectedDate,
              onTap: () => _pickDate(context),
            ),
            const SizedBox(height: 24),
            const Text('Alasan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Contoh: Ada urusan keluarga...',
                hintStyle: const TextStyle(color: AppTheme.neutral400, fontSize: 14),
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
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _canSubmit() && !_isSubmitting ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Ajukan Tukar Jadwal',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canSubmit() =>
      _selectedMember != null && _selectedDate != null && _reasonController.text.trim().isNotEmpty;

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    await ref.read(swapRepositoryProvider).createRequest(
      _selectedMember!,
      _selectedDate!,
      _reasonController.text.trim(),
    );
    ref.read(notificationServiceProvider).notify(
      NotificationType.swapRequest,
      'Permintaan Tukar Jadwal',
      'Budi meminta tukar jadwal dengan $_selectedMember',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permintaan tukar jadwal berhasil dikirim')),
      );
      context.pop();
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppTheme.primary),
      ), child: child!),
    );
    if (date != null) setState(() => _selectedDate = date);
  }
}

class _MemberSelector extends StatelessWidget {
  final List<String> members;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _MemberSelector({required this.members, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: members.map((m) {
        final isSelected = m == selected;
        return GestureDetector(
          onTap: () => onSelected(m),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary : AppTheme.neutral50,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected ? AppTheme.primary : AppTheme.neutral200,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: isSelected ? Colors.white.withOpacity(0.2) : AppTheme.primary.withOpacity(0.15),
                  child: Text(m[0],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppTheme.primary,
                      )),
                ),
                const SizedBox(width: 8),
                Text(m,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isSelected ? Colors.white : AppTheme.neutral800,
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const _DatePickerTile({required this.selectedDate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final dayNames = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.neutral50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.neutral200),
        ),
        child: Row(
          children: [
            Icon(
              selectedDate != null ? Icons.event_rounded : Icons.event_outlined,
              color: selectedDate != null ? AppTheme.primary : AppTheme.neutral400,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDate != null
                    ? '${dayNames[selectedDate!.weekday]}, ${selectedDate!.day} ${monthNames[selectedDate!.month]} ${selectedDate!.year}'
                    : 'Pilih tanggal',
                style: TextStyle(
                  color: selectedDate != null ? AppTheme.neutral800 : AppTheme.neutral400,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
