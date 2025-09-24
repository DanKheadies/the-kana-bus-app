import 'dart:typed_data';

import 'package:kana_bus_app/barrel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:logger/logger.dart';

class StorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final Logger log = Logger();

  Future<String> getDatabaseUrl({
    required User user,
    required String imageName,
    required String bucket,
  }) async {
    String downloadUrl =
        await storage.ref('$bucket/${user.id}/$imageName').getDownloadURL();

    return downloadUrl;
  }

  Future<String> uploadImage({
    required User user,
    required Uint8List bytes,
    required String imageName,
  }) async {
    try {
      String downloadUrl = await storage
          .ref('userProfilePictures/${user.id}/$imageName')
          .putData(bytes)
          .then(
            (snap) => UserRepository().updateUserPicture(
              bucket: 'userProfilePictures',
              imageName: imageName,
              user: user,
            ),
          );

      return downloadUrl;
    } catch (err) {
      log.e('uploading image error', error: err);
      throw Exception(err);
    }
  }

  Future<void> removeProfileImage({required String url}) async {
    try {
      firebase_storage.Reference storageDoc = storage.refFromURL(url);
      await storage.ref(storageDoc.fullPath).delete();
    } catch (err) {
      log.e('removing image error', error: err);
    }
  }
}
