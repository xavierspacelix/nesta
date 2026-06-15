import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/rent_record.dart';
import '../repositories/rent_repository.dart';
import '../repositories/supabase_rent_repository.dart';

final rentRepositoryProvider = Provider<IRentRepository>((ref) {
  return SupabaseRentRepository(Supabase.instance.client);
});

final rentHistoryProvider = FutureProvider<List<RentRecord>>((ref) {
  return ref.watch(rentRepositoryProvider).getRentHistory();
});
