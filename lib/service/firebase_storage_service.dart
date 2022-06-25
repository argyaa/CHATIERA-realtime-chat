import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(String imagePath) async {
    Reference storageRef = storage.ref(_auth.currentUser!.uid);
    File file = File(imagePath);

    try {
      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } on FirebaseException catch (e) {
      print("error di uploadImage");
      throw Exception(e);
    }
  }
}
