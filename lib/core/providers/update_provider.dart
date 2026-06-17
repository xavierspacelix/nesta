import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_version.dart';
import '../repositories/version_repository.dart';

enum UpdateStatus { upToDate, optional, force }

class UpdateCheckResult {
  final UpdateStatus status;
  final AppVersion? version;

  const UpdateCheckResult({required this.status, this.version});
}

final versionRepositoryProvider = Provider<IVersionRepository>((ref) {
  return SupabaseVersionRepository(Supabase.instance.client);
});

final updateCheckProvider = FutureProvider<UpdateCheckResult>((ref) async {
  final repo = ref.read(versionRepositoryProvider);
  final latest = await repo.getLatestVersion();

  if (latest == null) {
    return const UpdateCheckResult(status: UpdateStatus.upToDate);
  }

  final info = await PackageInfo.fromPlatform();
  final currentBuild = int.tryParse(info.buildNumber) ?? 0;

  if (currentBuild >= latest.buildNumber) {
    return UpdateCheckResult(status: UpdateStatus.upToDate, version: latest);
  }

  final status = latest.forceUpdate ? UpdateStatus.force : UpdateStatus.optional;
  return UpdateCheckResult(status: status, version: latest);
});
