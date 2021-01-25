import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:personal_trainer_app/core/services/image_selection_service.dart/image_selection_service_interface.dart';

class ImageSelectionService extends ImageSelectionServiceInterface {
  final _picker = ImagePicker();

  @override
  Future<File> chooseImageFromStorage() async {
    try {
      var pickedFile = await _picker.getImage(source: ImageSource.gallery);
      var imageFile = File(pickedFile.path);
      return imageFile;
    } catch (e) {
      return null;
    }
  }
}
