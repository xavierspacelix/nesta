class AppVersion {
  final String id;
  final String version;
  final int buildNumber;
  final bool forceUpdate;
  final String changelog;
  final String apkUrl;
  final DateTime createdAt;

  const AppVersion({
    required this.id,
    required this.version,
    required this.buildNumber,
    required this.forceUpdate,
    required this.changelog,
    required this.apkUrl,
    required this.createdAt,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      id: json['id'] as String,
      version: json['version'] as String,
      buildNumber: json['build_number'] as int,
      forceUpdate: json['force_update'] as bool,
      changelog: json['changelog'] as String? ?? '',
      apkUrl: json['apk_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'build_number': buildNumber,
      'force_update': forceUpdate,
      'changelog': changelog,
      'apk_url': apkUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
