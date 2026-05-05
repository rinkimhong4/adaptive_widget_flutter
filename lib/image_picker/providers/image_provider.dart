import 'dart:io';
import 'package:flutter/material.dart';
import '../services/image_picker_service.dart';
import '../services/upload_service.dart';

class ImageProviderX extends ChangeNotifier {
  final ImagePickerService picker;
  final UploadService uploader;

  ImageProviderX({required this.picker, required this.uploader});

  File? singleImage;
  List<File> multipleImages = [];
  bool isLoading = false;
  List<String> uploadedUrls = [];

  // Pick single
  Future<void> pickFromGallery() async {
    final file = await picker.pickFromGallery();
    if (file != null) {
      singleImage = file;
      notifyListeners();
    }
  }

  Future<void> pickFromCamera() async {
    final file = await picker.pickFromCamera();
    if (file != null) {
      singleImage = file;
      notifyListeners();
    }
  }

  // Pick multiple
  Future<void> pickMultiple({int? max}) async {
    final files = await picker.pickMultiple(max: max);
    multipleImages = files;
    notifyListeners();
  }

  // Upload single
  Future<void> uploadSingle() async {
    if (singleImage == null) return;

    isLoading = true;
    notifyListeners();

    final url = await uploader.upload(singleImage!);
    uploadedUrls.add(url);

    if (url != null) {
      uploadedUrls.add(url);
    }

    isLoading = false;
    notifyListeners();
  }

  // Upload multiple
  Future<void> uploadMultiple() async {
    if (multipleImages.isEmpty) return;

    isLoading = true;
    notifyListeners();

    for (var file in multipleImages) {
      final url = await uploader.upload(file);
      uploadedUrls.add(url);
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    singleImage = null;
    multipleImages.clear();
    uploadedUrls.clear();
    notifyListeners();
  }
}
