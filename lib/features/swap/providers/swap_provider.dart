import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/swap_request.dart';
import '../repositories/swap_repository.dart';
import '../repositories/supabase_swap_repository.dart';

final swapRepositoryProvider = Provider<ISwapRepository>((ref) {
  return SupabaseSwapRepository(Supabase.instance.client);
});

final membersProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(swapRepositoryProvider).getMembers();
});

final pendingSwapsProvider = FutureProvider<List<SwapRequest>>((ref) {
  return ref.watch(swapRepositoryProvider).getPendingRequests();
});
