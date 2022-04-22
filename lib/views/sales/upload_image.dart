import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

final picker = ImagePicker();

Future<void> uploadImage() async {
  // Select image from user's gallery
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    print('No image selected');
    return;
  }

  // Upload image with the current time as the key
  final key = DateTime.now().toString();
  final file = File(pickedFile.path);
  try {
    final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: file,
        key: key,
        onProgress: (progress) {
          print("Fraction completed: " +
              progress.getFractionCompleted().toString());
        });
    print('Successfully uploaded image: ${result.key}');
  } on StorageException catch (e) {
    print('Error uploading image: $e');
  }
}
