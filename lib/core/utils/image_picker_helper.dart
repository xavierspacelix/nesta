import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<({List<int> bytes, String fileName})?> pickFromGallery() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    return (bytes: bytes, fileName: fileName);
  }

  static Future<({List<int> bytes, String fileName})?> pickFromCamera() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    return (bytes: bytes, fileName: fileName);
  }
}
