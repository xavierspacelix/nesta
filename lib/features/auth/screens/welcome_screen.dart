import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum _SupabaseStatus { checking, connected, disconnected }

final _supabaseStatusProvider = FutureProvider<_SupabaseStatus>((ref) async {
  try {
    await Supabase.instance.client.from('app_versions').select('id').limit(1);
    return _SupabaseStatus.connected;
  } catch (_) {
    return _SupabaseStatus.disconnected;
  }
});

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.home_rounded,
                  size: 44,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Nesta',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Atur rumah bersamamu\nlebih mudah dan transparan.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.neutral500,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 4),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : () => ref.read(authProvider.notifier).loginWithGoogle(),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/google_logo.png',
                        height: 20,
                        width: 20,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.g_mobiledata_rounded,
                          size: 24,
                          color: AppTheme.neutral700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Lanjutkan dengan Google',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : () => context.push('/login'),

                  child: const Text(
                    'Masuk dengan Email',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.neutral500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/register'),
                    child: Text(
                      'Daftar',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              _buildSupabasePill(ref),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupabasePill(WidgetRef ref) {
    final statusAsync = ref.watch(_supabaseStatusProvider);

    final (Color bg, Color textColor, String label) = statusAsync.when(
      loading: () => (AppTheme.neutral200, AppTheme.neutral600, 'Memeriksa koneksi...'),
      error: (_, __) => (AppTheme.error.withOpacity(0.15), AppTheme.error, 'Supabase: Error'),
      data: (status) {
        switch (status) {
          case _SupabaseStatus.connected:
            return (AppTheme.success.withOpacity(0.15), AppTheme.success, 'Supabase: Terhubung');
          case _SupabaseStatus.disconnected:
            return (AppTheme.error.withOpacity(0.15), AppTheme.error, 'Supabase: Gagal');
          case _SupabaseStatus.checking:
            return (AppTheme.neutral200, AppTheme.neutral600, 'Memeriksa koneksi...');
        }
      },
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
