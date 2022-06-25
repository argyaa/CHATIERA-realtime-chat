import 'package:chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> signInWithGoogle() async {
    try {
      GoogleSignInAccount? _currentUser = await _googleSignIn.signIn();
      // ignore: avoid_print
      print(_currentUser);
      final googleAuth = await _currentUser!.authentication;

      final userCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential _userCredential =
          await _auth.signInWithCredential(userCredential);

      // ignore: avoid_print
      print(_currentUser.id);
      // ignore: avoid_print
      print(_userCredential.user!.uid);

      UserModel user = UserModel(
        id: _userCredential.user!.uid,
        displayName: _userCredential.user!.displayName,
        email: _userCredential.user!.email,
        photoUrl: _userCredential.user!.photoURL,
        createdAt: _userCredential.user!.metadata.creationTime,
        lastUpdate: DateTime.now(),
        lastSignIn: _userCredential.user!.metadata.lastSignInTime,
        status: "Hey there Im using chatapp",
      );

      return user;
    } catch (error) {
      // ignore: avoid_print
      print("error di auth service");
      print(error);
      throw Exception(error);
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e);
      throw Exception(e);
    }
  }
}
