import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/features/settings/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/house_member.dart';
import '../repositories/members_repository.dart';
import '../repositories/supabase_members_repository.dart';

final membersRepositoryProvider = Provider<IMembersRepository>((ref) {
  return SupabaseMembersRepository(Supabase.instance.client);
});

final membersProvider = FutureProvider<List<HouseMember>>((ref) {
  return ref.watch(membersRepositoryProvider).getMembers();
});

final currentProfileProvider = FutureProvider<UserProfile?>((ref) {
  return ref.watch(membersRepositoryProvider).getCurrentProfile();
});
