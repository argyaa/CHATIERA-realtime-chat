import 'package:chat_app/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class MessageService {
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _messageReference =
      FirebaseFirestore.instance.collection('messages');

  Stream<QuerySnapshot> getAllMessage(String currentId) {
    return _userReference
        .doc(currentId)
        .collection("message")
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getFriendData(String id) {
    return _userReference.doc(id).snapshots();
  }

  Future addNewMessage(String currentId, String idFriend) async {
    try {
      return await _messageReference.add({
        "connections": [
          currentId,
          idFriend,
        ],
        "lastTime": DateTime.now(),
      });
    } on Exception catch (e) {
      print("error di addNewMessage");

      print(e);
      throw Exception(e);
    }
  }

  Future<QuerySnapshot> checkConnectionFriend(
      String currentId, String idFriend) async {
    try {
      QuerySnapshot chatDocs = await _messageReference.where(
        "connections",
        whereIn: [
          [
            currentId,
            idFriend,
          ],
          [
            idFriend,
            currentId,
          ]
        ],
      ).get();

      return chatDocs;
    } catch (e) {
      print("error di checkConnectionFriend");

      print(e);

      throw Exception(e);
    }
  }

  Future<ChatUser> getCurrentUserMessage(String currentId) async {
    try {
      QuerySnapshot snapshot =
          await _userReference.doc(currentId).collection("message").get();

      ChatUser _chatUser = ChatUser.fromJson(
          snapshot.docs[0].id, snapshot.docs[0].data() as Map<String, dynamic>);

      return _chatUser;
    } catch (e) {
      print("error di getCurrentUserMessage");

      print(e);
      throw Exception(e);
    }
  }

  Future addMessageDataCurrentUser(
      String currentId, String chatId, ChatUser _chatUser) async {
    try {
      await _userReference
          .doc(currentId)
          .collection("message")
          .doc(chatId)
          .set(_chatUser.toJson());
    } catch (e) {
      print("error di addMessageDataCurrentUser");

      print(e);
      throw Exception(e);
    }
  }

  // Future updateChatsDataInUser(
  //     String currentId, List<ChatUser>? _listChatUser) async {
  //   try {
  //     await _userReference
  //         .doc(currentId)
  //         .update({"chats": _listChatUser!.map((e) => e.toJson()).toList()});
  //   } catch (e) {
  //     print("error di updateChatsDataInUser");
  //     print(e);

  //     throw Exception(e);
  //   }
  // }

  Future<ChatUser> addNewConnection(String currentId, String idFriend) async {
    try {
      // ChatUser _chatUser =
      //     await MessageService().getCurrentUserMessage(currentId);

      // UserModel _user = await UserService().getUserById(currentId);
      final newChatDoc = await addNewMessage(currentId, idFriend);

      ChatUser _chatUser = ChatUser(
        connection: idFriend,
        lastTime: DateTime.now(),
      );

      await addMessageDataCurrentUser(currentId, newChatDoc.id, _chatUser);

      return _chatUser;
    } on Exception catch (e) {
      print("error di addNewConnection");

      print(e);
      throw Exception(e);
    }
  }
}
