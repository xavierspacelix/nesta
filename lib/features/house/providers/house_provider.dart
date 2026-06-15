import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/features/auth/providers/auth_provider.dart';
import 'package:nesta/features/house/repositories/house_repository.dart';
import 'package:nesta/features/house/repositories/supabase_house_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final houseRepositoryProvider = Provider<IHouseRepository>((ref) {
  return SupabaseHouseRepository(Supabase.instance.client);
});

final houseProvider = FutureProvider<House?>((ref) async {
  final authState = ref.watch(authProvider);
  final userId = authState.userId;
  if (userId == null) return null;

  final repository = ref.watch(houseRepositoryProvider);
  return repository.getHouseByUserId(userId);
});
