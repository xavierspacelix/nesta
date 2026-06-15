import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/water_schedule.dart';
import '../repositories/water_repository.dart';
import '../repositories/supabase_water_repository.dart';

final waterRepositoryProvider = Provider<IWaterRepository>((ref) {
  return SupabaseWaterRepository(Supabase.instance.client);
});

final waterScheduleProvider = FutureProvider<WaterSchedule>((ref) {
  return ref.watch(waterRepositoryProvider).getSchedule();
});
