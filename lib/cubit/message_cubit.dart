import 'package:bloc/bloc.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/service/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageCubit extends Cubit<void> {
  MessageCubit() : super(null);

  Stream<QuerySnapshot> getAllMessageStream(String currentId) {
    return MessageService().getAllMessage(currentId);
  }

  Stream<DocumentSnapshot> getFriendData(String id) {
    return MessageService().getFriendData(id);
  }

  Stream<QuerySnapshot> getLastMessage(String chatId) {
    return ChatService().getChat(chatId);
  }
}
