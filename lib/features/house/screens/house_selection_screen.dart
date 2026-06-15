import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nesta/app/theme/app_theme.dart';

class HouseSelectionScreen extends StatelessWidget {
  const HouseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.maps_home_work_rounded, size: 32, color: AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Mulai perjalanan\nbareng Nesta',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(height: 1.2),
              ),
              const SizedBox(height: 8),
              Text(
                'Kamu bisa membuat rumah baru atau bergabung dengan rumah yang sudah ada.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.neutral500,
                ),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () => context.push('/house/create'),
                child: const Text('Buat Rumah Baru'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.push('/house/join'),
                child: const Text('Gabung Rumah'),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
