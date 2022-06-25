import 'package:chat_app/cubit/auth_cubit.dart';
import 'package:chat_app/cubit/message_cubit.dart';
import 'package:chat_app/screen/home/widgets/message_item.dart';
import 'package:chat_app/service/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat_model.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    noMessage() {
      return const Center(
        child: Text("no data"),
      );
    }

    loadingMessage() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    message(String currentId) {
      return StreamBuilder<QuerySnapshot>(
          stream: context.read<MessageCubit>().getAllMessageStream(currentId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // semua data chats di user
              // final _chats = (snapshot.data!.data()
              //     as Map<String, dynamic>)['chats'] as List;

              // sorting data chats berdasarkan last time terbaru
              // _chats.sort((a, b) {
              //   var timeA = (a['lastTime'] as Timestamp).toDate();
              //   var timeB = (b['lastTime'] as Timestamp).toDate();
              //   return timeB.compareTo(timeA);
              // });
              return Column(
                children: snapshot.data!.docs.map((_message) {
                  var _messageData = _message.data() as Map<String, dynamic>;

                  return StreamBuilder<DocumentSnapshot>(
                      stream: context
                          .read<MessageCubit>()
                          .getFriendData(_messageData['connection']),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          final _friendData =
                              snapshot2.data!.data() as Map<String, dynamic>;

                          return StreamBuilder<QuerySnapshot>(
                              stream: context
                                  .read<MessageCubit>()
                                  .getLastMessage(_message.id),
                              builder: (context, snapshot3) {
                                if (snapshot3.hasData) {
                                  final List<ChatModel> _chatData =
                                      snapshot3.data!.docs.map((e) {
                                    return ChatModel.fromJson(
                                        e.data() as Map<String, dynamic>);
                                    // return (e.data()
                                    //         as Map<String, dynamic>)["msg"]
                                    //     .toString();
                                  }).toList();

                                  if (_chatData.isNotEmpty) {
                                    return MessageItem(
                                      messageId: _message.id,
                                      friendId: _messageData['connection'],
                                      image: _friendData['photoUrl'],
                                      name: _friendData['displayName'],
                                      message: _chatData.last.msg,
                                      isRead: _chatData.last.isRead!,
                                      isSender: _chatData.last.pengirim! !=
                                          _messageData['connection'],
                                      time: (_messageData['lastTime']
                                              as Timestamp)
                                          .toDate(),
                                      count: _messageData['total_unread'],
                                    );
                                  }
                                }

                                // KETIKE TIDAK ADA DATA
                                return MessageItem(
                                  messageId: _message.id,
                                  friendId: _messageData['connection'],
                                  image: _friendData['photoUrl'],
                                  name: _friendData['displayName'],
                                  message: "tap here to chat with your friend",
                                  isRead: false,
                                  isSender: true,
                                  time: (_messageData['lastTime'] as Timestamp)
                                      .toDate(),
                                  count: _messageData['total_unread'],
                                );
                              });
                        }
                        return loadingMessage();
                      });
                }).toList(),
              );
            }

            return noMessage();
          });
    }

    return ListView(
      // padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      children: [
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return message(state.user.id.toString());
            }
            return loadingMessage();
          },
        ),
      ],
    );
  }
}
