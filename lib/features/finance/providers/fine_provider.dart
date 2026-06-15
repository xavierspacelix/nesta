import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/fine_entry.dart';
import '../repositories/fine_repository.dart';
import '../repositories/supabase_fine_repository.dart';

final fineRepositoryProvider = Provider<IFineRepository>((ref) {
  return SupabaseFineRepository(Supabase.instance.client);
});

final currentFinesProvider = FutureProvider<List<FineEntry>>((ref) {
  final repo = ref.watch(fineRepositoryProvider);
  return repo.getCurrentFines();
});

final fineHistoryProvider = FutureProvider<List<FineEntry>>((ref) {
  final repo = ref.watch(fineRepositoryProvider);
  return repo.getFineHistory();
});

final monthlyFineTotalProvider = FutureProvider<int>((ref) {
  final repo = ref.watch(fineRepositoryProvider);
  return repo.getMonthlyTotal();
});

final fineByIdProvider = FutureProvider.family<FineEntry?, String>((ref, id) {
  final repo = ref.watch(fineRepositoryProvider);
  return repo.getFineById(id);
});
