import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_verification.dart';
import '../repositories/task_verification_repository.dart';
import '../repositories/supabase_task_verification_repository.dart';

final taskVerificationRepositoryProvider = Provider<ITaskVerificationRepository>((ref) {
  return SupabaseTaskVerificationRepository(Supabase.instance.client);
});

final taskVerificationProvider = FutureProvider.family<TaskVerification, String>((ref, taskId) {
  final repository = ref.watch(taskVerificationRepositoryProvider);
  return repository.getVerification(taskId);
});
