import 'package:image_picker/image_picker.dart';
import 'package:nesta/core/services/logger.dart';

class ImagePickerHelper {
  static Future<({List<int> bytes, String fileName})?> pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (file == null) return null;
      final bytes = await file.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      return (bytes: bytes, fileName: fileName);
    } catch (e) {
      Log.e('ImagePicker', 'pickFromGallery failed', e);
      return null;
    }
  }

  static Future<({List<int> bytes, String fileName})?> pickFromCamera() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (file == null) return null;
      final bytes = await file.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      return (bytes: bytes, fileName: fileName);
    } catch (e) {
      Log.e('ImagePicker', 'pickFromCamera failed', e);
      return null;
    }
  }
}
