import 'package:bloc/bloc.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screen/home/chat_room/chat_room_screen.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../service/message_service.dart';

part 'people_state.dart';

class PeopleCubit extends Cubit<PeopleState> {
  PeopleCubit() : super(PeopleInitial());

  bool flagNewConnection = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void searchPeople(String query) async {
    try {
      emit(PeopleLoading());

      // ignore: unnecessary_new
      RegExp pattern = new RegExp(
        query,
        caseSensitive: false,
        multiLine: false,
      );

      List<UserModel> user =
          await UserService().searchPeople(query, _auth.currentUser!.uid);

      List<UserModel> result =
          user.where((e) => e.displayName!.startsWith(pattern)).toList();
      // print(result.map((e) => print(e.displayName)).toList());

      emit(PeopleSuccess(result));
    } catch (e) {
      // ignore: avoid_print
      print("error di people cubit");
      emit(PeopleFailed(e.toString()));
    }
  }

  Future<void> addNewConnection(String idFriend) async {
    try {
      late String chatId;

      // GET MESSAGE DI USER

      final _messageUser =
          await UserService().getUserMessage(_auth.currentUser!.uid);

      // final docUser = await UserService().getUserById(_auth.currentUser!.uid);

      if (_messageUser.isNotEmpty) {
        // GET MESSAGE DI USER YANG SAMA KONEKSINYA DENGAN ID FRIEND
        final docUserMessage = await UserService()
            .getUserMessageByIdFriend(_auth.currentUser!.uid, idFriend);

        if (docUserMessage.isNotEmpty) {
          // sudah pernah buat koneksi dengan => idFriend

          // dapatkan chatId nya
          chatId = docUserMessage[0].chatId.toString();
          print(chatId);
          flagNewConnection = false;
        } else {
          // belum pernah buat koneksi dengan => idFriend
          flagNewConnection = true;
        }
      } else {
        // belum pernah buat koneksi dengan siapapun
        flagNewConnection = true;
      }

      if (flagNewConnection) {
        // cek dari chats collection => connections => mereka berdua
        // cek apakah ada koneksi antara 2 orang
        final chatDocs = await MessageService()
            .checkConnectionFriend(_auth.currentUser!.uid, idFriend);

        if (chatDocs.docs.isNotEmpty) {
          // terdapat data dari chats collection (sudah ada koneksi antara mereka berdua)
          final chatsDataId = chatDocs.docs[0].id;
          final chatsData = chatDocs.docs[0].data() as Map<String, dynamic>;

          ChatUser _chatUser = ChatUser(
            connection: idFriend,
            lastTime: (chatsData['lastTime'] as Timestamp).toDate(),
          );

          await MessageService().addMessageDataCurrentUser(
            _auth.currentUser!.uid,
            chatsDataId,
            _chatUser,
          );

          chatId = chatsDataId;
        } else {
          // belum ada koneksi antara 2 orang
          // menambahkan connection baru

          final _newConnection = await MessageService()
              .addNewConnection(_auth.currentUser!.uid, idFriend);

          chatId = _newConnection.chatId.toString();
          print("menambahkan new connection");
        }
      }

      // Get.to(ChatRoomScreen(chatId: chatId, friendId: idFriend));
      Get.back();
    } on Exception catch (e) {
      emit(PeopleFailed(e.toString()));
    }
  }

  Stream<DocumentSnapshot> getFriendData(String friendId) {
    return UserService().getFriendData(friendId);
  }
}
