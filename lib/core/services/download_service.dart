import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio;

  DownloadService() : _dio = Dio();

  Future<String> downloadApk(String url, {void Function(int, int)? onProgress}) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/nesta_update.apk';

    await _dio.download(
      url,
      path,
      onReceiveProgress: onProgress,
    );

    return path;
  }

  Future<void> installApk(String path) async {
    final result = await OpenFilex.open(path, type: 'application/vnd.android.package-archive');
    if (result.type != ResultType.done) {
      throw Exception('Install failed: ${result.message}');
    }
  }

  static Future<void> openInstallSettings() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await OpenFilex.open('package:com.android.settings');
    }
  }
}
