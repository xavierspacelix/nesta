import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'logger.dart';

class StorageService {
  final SupabaseClient _client;
  static const String bucketName = 'nesta';

  StorageService(this._client);

  Future<String> uploadFile({
    required String folder,
    required String fileName,
    required List<int> bytes,
  }) async {
    try {
      final path = '$folder/$fileName';
      await _client.storage.from(bucketName).uploadBinary(
        path,
        Uint8List.fromList(bytes),
        fileOptions: const FileOptions(upsert: true),
      );
      final url = _client.storage.from(bucketName).getPublicUrl(path);
      Log.i('Storage', 'uploaded: $path -> $url');
      return url;
    } catch (e) {
      Log.e('Storage', 'upload failed: $folder/$fileName', e);
      rethrow;
    }
  }
}
