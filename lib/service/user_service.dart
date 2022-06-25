import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUserToFirestore(UserModel user) async {
    try {
      await _userReference.doc(user.id).set({
        'id': user.id,
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
        'status': user.status,
        'keyName': user.displayName!.substring(0, 1).toUpperCase(),
        'createdAt': user.createdAt,
        'lastUpdate': user.lastUpdate,
        'lastSignIn': user.lastSignIn,
      });
    } catch (e) {
      // ignore: avoid_print
      print("error di addUserToFirestore");
      // ignore: avoid_print
      print(e);
      throw Exception(e);
    }
  }

  Future<void> updateLastSignInUser(UserModel user) async {
    try {
      await _userReference.doc(user.id).update({'lastSignIn': DateTime.now()});
    } catch (e) {
      // ignore: avoid_print
      print("error di updateLastSignInUser");
      // ignore: avoid_print
      print(e);
      throw Exception(e);
    }
  }

  Future<UserModel> updateProfileUser(
      String id, String displayName, String status, String imageUrl) async {
    try {
      UserModel user = await getUserById(id);

      user
        ..photoUrl = imageUrl
        ..displayName = displayName
        ..status = status
        ..lastUpdate = DateTime.now();

      await _userReference.doc(id).update({
        'keyName': displayName.substring(0, 1).toUpperCase(),
        'displayName': displayName,
        'photoUrl': imageUrl,
        'status': status,
        'lastUpdate': DateTime.now(),
      });

      return user;
    } catch (e) {
      // ignore: avoid_print
      print("error di updateProfileUser");
      // ignore: avoid_print
      print(e);
      throw Exception(e);
    }
  }

  Future<UserModel> updateProfileUserIfImageIsNull(
      String id, String displayName, String status) async {
    try {
      UserModel user = await getUserById(id);

      user
        ..displayName = displayName
        ..status = status
        ..lastUpdate = DateTime.now();

      await _userReference.doc(id).update({
        'keyName': displayName.substring(0, 1).toUpperCase(),
        'displayName': displayName,
        'status': status,
        'lastUpdate': DateTime.now(),
      });

      return user;
    } catch (e) {
      // ignore: avoid_print
      print("error di updateProfileUser");
      // ignore: avoid_print
      print(e);
      throw Exception(e);
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(id).get();

      return UserModel.fromJson(id, snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      // ignore: avoid_print
      print("error di getUserById");
      // ignore: avoid_print
      print(e);
      throw Exception(e);
    }
  }

  Future<bool> isUserExist(String id) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(id).get();
      return snapshot.data() != null ? true : false;
    } catch (e) {
      // ignore: avoid_print
      print("error di isUserExist");
      // ignore: avoid_print
      print(e);
      throw Exception(e);
    }
  }

  Future<List<UserModel>> searchPeople(String query, String id) async {
    try {
      QuerySnapshot snapshot = await _userReference
          .where('keyName', isEqualTo: query.substring(0, 1).toUpperCase())
          .where('id', isNotEqualTo: id)
          .get();

      print("TOTAL DATA : " + snapshot.docs.length.toString());

      List<UserModel> user = snapshot.docs.map((e) {
        return UserModel.fromJson(e.id, e.data() as Map<String, dynamic>);
      }).toList();

      return user.isEmpty ? [] : user;
      // return user ?? [];
    } catch (e) {
      // ignore: avoid_print
      print("error di searchPeople");
      // ignore: avoid_print
      print(e);
      throw Exception(e);
    }
  }

  Future<List<ChatUser>> getUserMessage(String currentId) async {
    try {
      QuerySnapshot snapshot =
          await _userReference.doc(currentId).collection("message").get();

      List<ChatUser> _chatUser = snapshot.docs.map((e) {
        return ChatUser.fromJson(e.id, e.data() as Map<String, dynamic>);
      }).toList();

      return _chatUser.isEmpty ? [] : _chatUser;
    } catch (e) {
      print("error di getUserMessage");

      print(e);
      throw Exception(e);
    }
  }

  Future<List<ChatUser>> getUserMessageByIdFriend(
      String currentId, String IdFriend) async {
    try {
      QuerySnapshot snapshot = await _userReference
          .doc(currentId)
          .collection("message")
          .where('connection', isEqualTo: IdFriend)
          .get();

      List<ChatUser> _chatUser = snapshot.docs.map((e) {
        return ChatUser.fromJson(e.id, e.data() as Map<String, dynamic>);
      }).toList();

      return _chatUser;
    } catch (e) {
      print("error di getUserMessageByIdFriend");

      print(e);

      throw Exception(e);
    }
  }

  Stream<DocumentSnapshot> getFriendData(String friendId) {
    return _userReference.doc(friendId).snapshots();
  }
}
