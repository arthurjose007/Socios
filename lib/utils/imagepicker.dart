import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

imagepicker(ImageSource imageSource) async {
  final ImagePicker imagepick = ImagePicker();
  XFile? _files = await imagepick.pickImage(source: imageSource);

  if (_files != null) {
    return await _files.readAsBytes();
  }
  print("No image selected");
}

showSnackBarhear(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
