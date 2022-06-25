import 'package:chat_app/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/user_model.dart';

class ChatService {
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _messageReference =
      FirebaseFirestore.instance.collection('messages');

  Stream<QuerySnapshot> getChat(String chatId) {
    return _messageReference
        .doc(chatId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future addNewChat(
      String currentId, String friendId, String chatId, String chat) async {
    await _messageReference.doc(chatId).collection('chats').add({
      "pengirim": currentId,
      "penerima": friendId,
      "msg": chat,
      "groupTime": DateFormat.yMMMd('en_US').format(DateTime.now()),
      "time": DateTime.now(),
      "isRead": false,
    });
  }

  Future updateMessageDataInCurrentUser(
      String currentId, String chatId, int totalUnread) async {
    try {
      await _userReference
          .doc(currentId)
          .collection("message")
          .doc(chatId)
          .update({
        'lastTime': DateTime.now(),
        'total_unread': totalUnread,
      });
    } catch (e) {
      print("error di updateMessageDataInCurrentUser");

      print(e);
      throw Exception(e);
    }
  }

  Future updatetotalUnreadInCurrentUser(
      String currentId, String chatId, int totalUnread) async {
    try {
      await _userReference
          .doc(currentId)
          .collection("message")
          .doc(chatId)
          .update({'total_unread': totalUnread});
    } catch (e) {
      print("error di updateMessageDataInCurrentUser");

      print(e);
      throw Exception(e);
    }
  }

  Future<bool> isMessageDataInFriendExist(
      String idFriend, String chatId) async {
    try {
      final snapshot = await _userReference
          .doc(idFriend)
          .collection("message")
          .doc(chatId)
          .get();

      return snapshot.data() != null ? true : false;
    } catch (e) {
      print("error di isMessageDataInFriendExist");

      print(e);

      throw Exception(e);
    }
  }

  Future createMessageDataInFriend(
      String idFriend, String currentId, String chatId, int totalUnread) async {
    try {
      await _userReference.doc(idFriend).collection("message").doc(chatId).set({
        'connection': currentId,
        'lastTime': DateTime.now(),
        'total_unread': totalUnread,
      });
    } catch (e) {
      print('error di createMessageDataInFriend');

      print(e);

      throw Exception(e);
    }
  }

  Future getMessageDataInFriend(String idFriend, String chatId) async {
    try {
      final snapshot = await _userReference
          .doc(idFriend)
          .collection("message")
          .doc(chatId)
          .get();
      return snapshot;
    } catch (e) {
      print('getMessageDataInFriend');

      print(e);

      throw Exception(e);
    }
  }

  Future updateMessageDataInFriend(
      String idFriend, String currentId, String chatId, int totalUnread) async {
    try {
      await _userReference
          .doc(idFriend)
          .collection("message")
          .doc(chatId)
          .update({
        'lastTime': DateTime.now(),
        'total_unread': totalUnread,
      });
    } catch (e) {
      print('error di updateMessageDataInFriend');

      print(e);

      throw Exception(e);
    }
  }

  Future<QuerySnapshot> getUnreadChat(String friendId, String chatId) async {
    try {
      final snapshot = await _messageReference
          .doc(chatId)
          .collection("chats")
          .where("isRead", isEqualTo: false)
          .where("pengirim", isEqualTo: friendId)
          .get();

      return snapshot;
    } catch (e) {
      print("error di getLastUnread");
      print(e);

      throw Exception(e);
    }
  }

  Future updateIsRead(String roomChatId, String chatId) async {
    try {
      await _messageReference
          .doc(roomChatId)
          .collection("chats")
          .doc(chatId)
          .update({"isRead": true});
    } catch (e) {
      print("error di updateIsRead");
      print(e);

      throw Exception(e);
    }
  }
}
