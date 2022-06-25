import 'package:bloc/bloc.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:meta/meta.dart';

import '../screen/home/chat_room/chat_room_screen.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<void> {
  ChatCubit() : super(null);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  int totalUnread = 0;

  void addNewChat(String chatId, String friendId, String chat) async {
    await ChatService().addNewChat(
      _auth.currentUser!.uid,
      friendId,
      chatId,
      chat,
    );

    await ChatService()
        .updateMessageDataInCurrentUser(_auth.currentUser!.uid, chatId, 0);

    // cek apakah ada data message di friend
    final isDataInFriendExist =
        await ChatService().isMessageDataInFriendExist(friendId, chatId);

    if (isDataInFriendExist) {
      // final dataMessageFriend =
      //     await ChatService().getMessageDataInFriend(friendId, chatId);
      // totalUnread = (dataMessageFriend.data()
      //     as Map<String, dynamic>)['total_unread'] as int;

      // dapatkan data chat yang belum di read
      final unreadChat =
          await ChatService().getUnreadChat(_auth.currentUser!.uid, chatId);

      totalUnread = unreadChat.docs.length;

      // update
      await ChatService().updateMessageDataInFriend(
          friendId, _auth.currentUser!.uid, chatId, totalUnread);
    } else {
      // create new
      await ChatService().createMessageDataInFriend(
          friendId, _auth.currentUser!.uid, chatId, totalUnread + 1);
    }
  }

  Stream<QuerySnapshot> getChat(String chatId) {
    return ChatService().getChat(chatId);
  }

  void gotoChatRoom(String chatId, String friendId) async {
    // dapatkan chat yang belum di read
    final unreadChat = await ChatService().getUnreadChat(friendId, chatId);

    // ubah setiap chat yang belum di read menjadi true
    unreadChat.docs.forEach((element) async {
      await ChatService().updateIsRead(chatId, element.id);
    });

    // ubah total unread di current user menjadi 0
    await ChatService()
        .updatetotalUnreadInCurrentUser(_auth.currentUser!.uid, chatId, 0);

    Get.to(ChatRoomScreen(chatId: chatId, friendId: friendId));
  }
}
