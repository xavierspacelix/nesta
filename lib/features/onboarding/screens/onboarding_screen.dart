import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  String? _selectedRoom;
  bool _saving = false;

  final List<String> _mockRooms = [
    'Kamar Utama',
    'Kamar Depan',
    'Kamar Belakang',
    'Kamar Atas'
  ];

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);

    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) throw 'Sesi tidak ditemukan, silakan login ulang.';

      await client
          .from('profiles')
          .update({'nickname': _nicknameController.text.trim()})
          .eq('id', user.id);

      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan profil: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Lengkapi\nProfilmu',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(height: 1.2),
              ),
              const SizedBox(height: 8),
              Text(
                'Satu langkah lagi untuk mulai mengatur rumah bersama.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.neutral500,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.neutral100,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.neutral200),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 48,
                        color: AppTheme.neutral400,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Panggilan',
                        hintText: 'Misal: Budi',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama panggilan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedRoom,
                      decoration: const InputDecoration(
                        labelText: 'Pilih Kamar',
                        hintText: 'Pilih kamar yang akan kamu tempati',
                      ),
                      items: _mockRooms.map((String room) {
                        return DropdownMenuItem(
                          value: room,
                          child: Text(room),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRoom = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Silakan pilih kamar';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ElevatedButton(
            onPressed: _saving ? null : _handleComplete,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Selesai'),
          ),
        ),
      ),
    );
  }
}
