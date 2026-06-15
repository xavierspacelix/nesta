import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';

class EmailConfirmationScreen extends ConsumerStatefulWidget {
  final String email;

  const EmailConfirmationScreen({super.key, required this.email});

  @override
  ConsumerState<EmailConfirmationScreen> createState() => _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends ConsumerState<EmailConfirmationScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      ref.read(authProvider.notifier).checkSession();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        _timer?.cancel();
        if (next.houseId != null) {
          context.go('/dashboard');
        } else {
          context.go('/house/select');
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _timer?.cancel();
            context.go('/register');
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.email_outlined, size: 40, color: AppTheme.warning),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Cek Email Kamu',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Kami sudah mengirim link konfirmasi ke',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.neutral500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Klik link di email untuk mengaktifkan akunmu.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutral400,
                ),
              ),
              const Spacer(flex: 1),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.neutral50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.neutral200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 20, color: AppTheme.neutral500),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Halaman ini akan otomatis redirect setelah email dikonfirmasi.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutral500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(authProvider.notifier).checkSession();
                },
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Cek Ulang'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  _timer?.cancel();
                  context.go('/register');
                },
                child: const Text('Gunakan email lain'),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
