import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/chores/providers/room_provider.dart';
import 'package:nesta/features/finance/models/rent_record.dart';
import 'package:nesta/features/finance/providers/rent_provider.dart';
import 'package:nesta/features/finance/repositories/rent_repository.dart';
import 'package:nesta/features/finance/repositories/supabase_rent_repository.dart';
import 'package:nesta/features/members/providers/members_provider.dart';
import 'package:nesta/features/schedule/providers/schedule_provider.dart';
import 'package:nesta/features/schedule/repositories/schedule_repository.dart';
import 'package:nesta/features/schedule/repositories/supabase_schedule_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _rentRepoProvider = Provider<IRentRepository>((ref) {
  return SupabaseRentRepository(Supabase.instance.client);
});

final _scheduleRepoProvider = Provider<IScheduleRepository>((ref) {
  return SupabaseScheduleRepository(Supabase.instance.client);
});

class HomeManagementScreen extends ConsumerStatefulWidget {
  const HomeManagementScreen({super.key});

  @override
  ConsumerState<HomeManagementScreen> createState() => _HomeManagementScreenState();
}

class _HomeManagementScreenState extends ConsumerState<HomeManagementScreen> {
  final _rentController = TextEditingController();
  final _wifiController = TextEditingController();
  bool _saving = false;
  bool _generating = false;
  bool _initialized = false;

  @override
  void dispose() {
    _rentController.dispose();
    _wifiController.dispose();
    super.dispose();
  }

  void _prefillFromRecords(List<RentRecord> records) {
    if (_initialized) return;
    final now = DateTime.now();
    final current = records.where(
      (r) => r.year == now.year && r.month == now.month,
    ).firstOrNull;
    if (current != null) {
      _rentController.text = current.totalRent.toString();
      _wifiController.text = current.totalWifi.toString();
    }
    _initialized = true;
  }

  Future<void> _saveCosts() async {
    final rent = int.tryParse(_rentController.text.trim());
    final wifi = int.tryParse(_wifiController.text.trim());
    if (rent == null || wifi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan jumlah yang valid')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      await ref.read(_rentRepoProvider).setRentAmounts(now.year, now.month, rent, wifi);
      ref.invalidate(rentHistoryProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biaya berhasil disimpan')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan biaya')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _generateSchedule() async {
    final rooms = await ref.read(roomsProvider.future);
    if (rooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambah ruangan terlebih dahulu')),
      );
      return;
    }

    bool hasTasks = false;
    for (final room in rooms) {
      final tasks = await ref.read(checklistProvider(room.id).future);
      if (tasks.isNotEmpty) {
        hasTasks = true;
        break;
      }
    }
    if (!hasTasks) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambah tugas piket terlebih dahulu')),
      );
      return;
    }

    setState(() => _generating = true);
    try {
      await ref.read(_scheduleRepoProvider).initSchedule();
      ref.invalidate(scheduleProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jadwal piket berhasil dibuat')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuat jadwal')),
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentProfileProvider);
    final isOwner = profileAsync.valueOrNull?.role == 'Owner';
    final roomsAsync = ref.watch(roomsProvider);
    final rentAsync = ref.watch(rentHistoryProvider);

    rentAsync.whenData(_prefillFromRecords);

    final now = DateTime.now();
    final months = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

    final currentRecord = rentAsync.valueOrNull?.where(
      (r) => r.year == now.year && r.month == now.month,
    ).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Rumah'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Ruangan & Tugas'),
          const SizedBox(height: 8),
          roomsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('Gagal memuat ruangan'),
            data: (rooms) => Column(
              children: [
                _buildInfoTile('Ruangan', '${rooms.length} ruangan'),
                for (final room in rooms)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: _buildInfoTile(room.name, '${room.itemCount} tugas'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildActionTile('Atur Ruangan', Icons.meeting_room_outlined, onTap: () => context.push('/rooms')),
          const SizedBox(height: 24),
          _buildSectionHeader('Biaya Bulanan — ${months[now.month]} ${now.year}'),
          const SizedBox(height: 8),
          if (currentRecord != null) ...[
            _buildInfoTile('Sewa', 'Rp${_formatRupiah(currentRecord.totalRent)}'),
            const SizedBox(height: 4),
            _buildInfoTile('WiFi', 'Rp${_formatRupiah(currentRecord.totalWifi)}'),
            const SizedBox(height: 12),
          ],
          TextFormField(
            controller: _rentController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Biaya Sewa (Rp)',
              hintText: 'Contoh: 1500000',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _wifiController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Biaya WiFi (Rp)',
              hintText: 'Contoh: 300000',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _saveCosts,
              child: _saving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Simpan Biaya'),
            ),
          ),
          if (isOwner) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('Generate Jadwal'),
            const SizedBox(height: 8),
            const Text(
              'Buat jadwal piket otomatis untuk 30 hari ke depan.',
              style: TextStyle(fontSize: 13, color: AppTheme.neutral500),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generating ? null : _generateSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _generating
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Generate Jadwal'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.neutral500));
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.neutral50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.neutral50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.neutral500),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 14)),
              const Spacer(),
              const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.neutral300),
            ],
          ),
        ),
      ),
    );
  }
}
