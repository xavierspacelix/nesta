import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/storage_provider.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/core/utils/image_picker_helper.dart';
import 'package:nesta/features/members/providers/members_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  String? _selectedRoom;
  bool _saving = false;
  List<int>? _avatarBytes;
  String? _avatarFileName;

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

  Future<void> _pickAvatar() async {
    final ctx = context;
    final picked = await showModalBottomSheet<({List<int> bytes, String fileName})?>(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Foto Profil', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await ImagePickerHelper.pickFromCamera();
                    if (ctx.mounted) Navigator.pop(ctx, picked);
                  },
                  icon: const Icon(Icons.camera_alt_rounded, size: 20),
                  label: const Text('Kamera', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await ImagePickerHelper.pickFromGallery();
                    if (ctx.mounted) Navigator.pop(ctx, picked);
                  },
                  icon: const Icon(Icons.photo_library_rounded, size: 20),
                  label: const Text('Galeri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );

    if (picked == null) return;
    setState(() {
      _avatarBytes = picked.bytes;
      _avatarFileName = picked.fileName;
    });
  }

  Future<void> _handleComplete() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);

    try {
      final nickname = _nicknameController.text.trim();

      String? avatarUrl;
      if (_avatarBytes != null && _avatarFileName != null) {
        try {
          final storage = ref.read(storageServiceProvider);
          avatarUrl = await storage.uploadFile(
            folder: 'avatars',
            fileName: _avatarFileName!,
            bytes: _avatarBytes!,
          );
        } catch (e) {
          Log.e('Onboarding', 'avatar upload failed', e);
        }
      }

      final repo = ref.read(membersRepositoryProvider);
      await repo.updateProfile(nickname: nickname, avatarUrl: avatarUrl);

      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan profil. Silakan coba lagi.')),
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
                child: GestureDetector(
                  onTap: _pickAvatar,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.neutral100,
                        backgroundImage: _avatarBytes != null
                            ? MemoryImage(Uint8List.fromList(_avatarBytes!))
                            : null,
                        child: _avatarBytes == null
                            ? const Icon(
                                Icons.person_outline_rounded,
                                size: 48,
                                color: AppTheme.neutral400,
                              )
                            : null,
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
