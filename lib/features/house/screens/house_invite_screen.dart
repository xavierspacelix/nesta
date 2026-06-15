import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';

class HouseInviteScreen extends StatelessWidget {
  const HouseInviteScreen({super.key});

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode undangan berhasil disalin!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inviteCode = GoRouterState.of(context).extra as String? ?? 'NESTA-XXXXXXXX';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/dashboard'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.check_circle_rounded, size: 40, color: AppTheme.success),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Rumah Berhasil\nDibuat!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(height: 1.2),
              ),
              const SizedBox(height: 8),
              Text(
                'Bagikan kode ini ke teman serumahmu agar mereka bisa bergabung.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.neutral500,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.neutral50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.neutral200),
                ),
                child: Column(
                  children: [
                    Text(
                      'KODE UNDANGAN',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.neutral500,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      inviteCode,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primary,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => _copyCode(context, inviteCode),
                icon: const Icon(Icons.copy_rounded, size: 20),
                label: const Text('Salin Kode'),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ElevatedButton(
            onPressed: () => context.go('/onboarding'),
            child: const Text('Lanjut ke Profil'),
          ),
        ),
      ),
    );
  }
}
