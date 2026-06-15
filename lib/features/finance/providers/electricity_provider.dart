import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/electricity_purchase.dart';
import '../repositories/electricity_repository.dart';
import '../repositories/supabase_electricity_repository.dart';

final electricityRepositoryProvider = Provider<IElectricityRepository>((ref) {
  return SupabaseElectricityRepository(Supabase.instance.client);
});

final electricityPurchasesProvider = FutureProvider<List<ElectricityPurchase>>((ref) {
  return ref.watch(electricityRepositoryProvider).getPurchases();
});
