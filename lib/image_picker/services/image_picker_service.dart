import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    return file != null ? File(file.path) : null;
  }

  Future<File?> pickFromCamera() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    return file != null ? File(file.path) : null;
  }

  Future<List<File>> pickMultiple({int? max}) async {
    final files = await _picker.pickMultiImage(imageQuality: 85, limit: max);
    return files.map((e) => File(e.path)).toList();
  }
}
