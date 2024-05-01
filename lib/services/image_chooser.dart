import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/actions.dart';
import '../utils/image_source.dart';

class ImageChooser {
  static ImageChooser? _instance;

  final ImagePicker _picker = ImagePicker();
  ImageChooser._();

  factory ImageChooser() {
    return _instance ??= ImageChooser._();
  }

  Future<String?> chooseImage(ImageSource source) async {
    var file = await _picker.pickImage(
      source: source,
      imageQuality: 25,
    );
    String? path = file?.path;
    return path;
  }

  Future<String?> chooseVideo() async {
    XFile? file = await _picker.pickMedia(
      imageQuality: 25,
    );
    String? path;
    if (file != null) {
      path = file.path;
    }
    return path;
  }

  Future<List<String>?> chooseMultiple() async {
    List<XFile>? file = await _picker.pickMultipleMedia(
      imageQuality: 25,
    );
    List<String> paths = [];
    String? path;
    for (var element in file) {
      paths.add(element.path);
    }
    return paths;
  }

  Future<String?> pickVideo(ImageSource source) async {
    XFile? file = await _picker.pickVideo(source: source);
    String? path;
    if (file != null) {
      path = file.path;
    }
    return path;
  }

  Future<String?> cropImage(String path) async {
    var file = await ImageCropper().cropImage(
      sourcePath: path,
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.original,
      //   CropAspectRatioPreset.ratio16x9,
      //   CropAspectRatioPreset.ratio5x3,
      // ],
    
    );

    String? imgPath = file?.path;
    return imgPath;
  }

  void pickImage(
      BuildContext context, Function(String path) onPickImage) async {
    String? source = await AppDialog.showBottomPanel<String?>(
        context, const ImageSourcePicker());

    if (source != null) {
      String? path = await chooseImage(
          source == "Camera" ? ImageSource.camera : ImageSource.gallery);
      try {
        String? croppedImage = await cropImage(path!);
        onPickImage(croppedImage ?? path);
      } catch (ex) {
        AppMessage.showMessage("No Image Selected");
      }
    }
  }
}
