import 'package:kana_bus_app/barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Logger _log;

  UserRepository({FirebaseFirestore? firebaseFirestore, Logger? log})
    : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
      _log = log ?? Logger();

  Future<String> getPhotoUrl({required String userId}) async {
    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(userId).get();

    if (snap.data() == null) {
      return '';
    }

    return User.fromSnapshot(snap).avatarUrl;
  }

  Future<String> updateUserPicture({
    required String imageName,
    required String bucket,
    required User user,
  }) async {
    String downloadUrl = await StorageRepository().getDatabaseUrl(
      bucket: bucket,
      imageName: imageName,
      user: user,
    );

    try {
      await _firebaseFirestore.collection('users').doc(user.id).update({
        'avatarUrl': downloadUrl,
      });

      return downloadUrl;
    } catch (err) {
      _log.e('updating user picture error', error: err);
      throw Exception(err);
    }
  }

  Future<bool> checkForUser({required String userId}) async {
    return (await _firebaseFirestore.collection('users').doc(userId).get())
        .exists;
  }

  Future<User> getUser({required String userId}) async {
    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(userId).get();

    if (snap.data() == null) {
      return User.emptyUser;
    }

    return User.fromSnapshot(snap);
  }

  Future<void> createUser({required User user}) async {
    if (!(await _firebaseFirestore.collection('users').doc(user.id).get())
        .exists) {
      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .set(
            user.toJson(
              // isFirebase: true
            ),
          );
    }
  }

  Future<void> updateUser({required User user}) async {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .set(
          user.toJson(
            // isFirebase: true
          ),
        );
  }
}
