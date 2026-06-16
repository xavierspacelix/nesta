import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

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
    await OpenFilex.open(path);
  }
}
