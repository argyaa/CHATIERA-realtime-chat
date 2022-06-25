import 'dart:async';
import 'dart:io';

import 'package:chat_app/cubit/chat_cubit.dart';
import 'package:chat_app/cubit/emoji_cubit.dart';
import 'package:chat_app/cubit/people_cubit.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/screen/home/chat_room/widgets/chat_item.dart';
import 'package:chat_app/shared/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/message_cubit.dart';
import '../../../cubit/theme_cubit.dart';
import '../../../service/chat_service.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatId, friendId;
  const ChatRoomScreen({
    Key? key,
    required this.chatId,
    required this.friendId,
  }) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scroll = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<ChatModel> _chatList;

  FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void addEmojiToText(Emoji emoji) {
    _chatController.text += emoji.emoji;
  }

  void removeEmoji() {
    if (_chatController.text.isNotEmpty) {
      _chatController.text =
          _chatController.text.substring(0, _chatController.text.length - 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state;
    var showEmoji = context.watch<EmojiCubit>().state;

    noMessage() {
      return const Center(
        child: Text("no chat"),
      );
    }

    appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () async {
              final unreadChat = await ChatService()
                  .getUnreadChat(widget.friendId, widget.chatId);

              // ubah setiap chat yang belum di read menjadi true
              unreadChat.docs.forEach((element) async {
                await ChatService().updateIsRead(widget.chatId, element.id);
              });

              // ubah total unread di current user menjadi 0
              await ChatService().updatetotalUnreadInCurrentUser(
                  _auth.currentUser!.uid, widget.chatId, 0);

              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDarkMode ? const Color(0xffF3F3F9) : Colors.black,
            )),
        title: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream:
                    context.read<MessageCubit>().getFriendData(widget.friendId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final _friendData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Text(
                      _friendData['displayName'],
                      style: GoogleFonts.dmSans(
                          fontSize: 18,
                          color: isDarkMode
                              ? const Color(0xffF3F3F9)
                              : Colors.black),
                    );
                  }
                  return const SizedBox();
                }),
            // Text(
            //   "last seen 6 minutes ago",
            //   style: GoogleFonts.dmSans(
            //       fontSize: 14, color: const Color(0xffBEBEBE)),
            // )
          ],
        ),
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: context.read<MessageCubit>().getFriendData(widget.friendId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final _friendData =
                    snapshot.data!.data() as Map<String, dynamic>;
                return CircleAvatar(
                  backgroundImage: NetworkImage(_friendData['photoUrl']),
                  radius: 20,
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(width: 24),
        ],
        centerTitle: true,
        backgroundColor:
            isDarkMode ? const Color(0xff1B2430) : const Color(0xffFCFCFC),
      );
    }

    dataMessage() {
      return Expanded(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: context.read<ChatCubit>().getChat(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _chatList = snapshot.data!.docs.map((chatData) {
                    return ChatModel.fromJson(
                        chatData.data() as Map<String, dynamic>);
                    // return ChatModel(
                    //     pengirim: chatData["pengirim"],
                    //     penerima: chatData["penerima"],
                    //     msg: chatData["msg"],
                    //     groupTime: chatData["groupTime"],
                    //     time: (chatData["time"] as Timestamp).toDate(),
                    //     isRead: chatData["isRead"]);
                  }).toList();

                  Timer(Duration.zero,
                      () => _scroll.jumpTo(_scroll.position.maxScrollExtent));

                  return ListView.builder(
                      controller: _scroll,
                      reverse: false,
                      itemCount: _chatList.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              const SizedBox(height: 24),
                              Text(_chatList[index].groupTime.toString()),
                              ChatItem(
                                isSender: _chatList[index].pengirim !=
                                    widget.friendId,
                                isRead: _chatList[index].isRead,
                                message: _chatList[index].msg.toString(),
                                time: _chatList[index].time,
                              )
                            ],
                          );
                        } else {
                          if (_chatList[index].groupTime ==
                              _chatList[index - 1].groupTime) {
                            return ChatItem(
                              isSender:
                                  _chatList[index].pengirim != widget.friendId,
                              isRead: _chatList[index].isRead,
                              message: _chatList[index].msg.toString(),
                              time: _chatList[index].time,
                            );
                          } else {
                            return Column(
                              children: [
                                Text(_chatList[index].groupTime.toString()),
                                ChatItem(
                                  isSender: _chatList[index].pengirim !=
                                      widget.friendId,
                                  isRead: _chatList[index].isRead,
                                  message: _chatList[index].msg.toString(),
                                  time: _chatList[index].time,
                                )
                              ],
                            );
                          }
                        }
                      });
                }

                return noMessage();
              }),
        ),
      );
    }

    textFieldChat() {
      return Container(
        color: isDarkMode ? const Color(0xff1B2430) : Colors.white,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: Scrollbar(
                  controller: _scrollController,
                  isAlwaysShown: true,
                  child: GestureDetector(
                    onTap: () {
                      Timer(
                          Duration.zero,
                          () =>
                              _scroll.jumpTo(_scroll.position.maxScrollExtent));
                    },
                    child: TextField(
                      focusNode: focusNode,
                      controller: _chatController,
                      scrollController: _scrollController,
                      style: GoogleFonts.dmSans(fontSize: 16),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      expands: true,
                      onTap: () {
                        context.read<EmojiCubit>().setShowEmoji(false);
                      },
                      cursorColor: isDarkMode ? Colors.white : Colors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(16, 4, 4, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        fillColor: isDarkMode
                            ? const Color(0xff2a384a)
                            : const Color(0xffF2F2F2),
                        filled: true,
                        prefixIcon: IconButton(
                          onPressed: () {
                            context.read<EmojiCubit>().setShowEmoji(!showEmoji);
                          },
                          icon: Icon(
                            Icons.emoji_emotions_outlined,
                            color: isDarkMode ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                if (_chatController.text.isNotEmpty) {
                  // dapatkan chat yang belum di read
                  final unreadChat = await ChatService()
                      .getUnreadChat(widget.friendId, widget.chatId);

                  // ubah setiap chat yang belum di read menjadi true
                  unreadChat.docs.forEach((element) async {
                    await ChatService().updateIsRead(widget.chatId, element.id);
                  });

                  // ubah total unread di current user menjadi 0
                  await ChatService().updatetotalUnreadInCurrentUser(
                      _auth.currentUser!.uid, widget.chatId, 0);

                  context.read<ChatCubit>().addNewChat(
                        widget.chatId,
                        widget.friendId,
                        _chatController.text,
                      );
                  _chatController.clear();
                }
              },
              behavior: HitTestBehavior.translucent,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: blue,
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    emoji() {
      return Container(
        height: 280,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            addEmojiToText(emoji);
          },
          onBackspacePressed: () {
            // Backspace-Button tapped logic
            // Remove this line to also remove the button in the UI
            removeEmoji();
          },
          config: Config(
              columns: 7,
              emojiSizeMax: 32 *
                  (Platform.isIOS
                      ? 1.30
                      : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
              verticalSpacing: 0,
              horizontalSpacing: 0,
              initCategory: Category.RECENT,
              bgColor: Color(0xFFF2F2F2),
              indicatorColor: blue,
              iconColor: Colors.grey,
              iconColorSelected: blue,
              progressIndicatorColor: blue,
              backspaceColor: blue,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              showRecentsTab: true,
              recentsLimit: 28,
              noRecentsText: "No Recents",
              noRecentsStyle:
                  const TextStyle(fontSize: 20, color: Colors.black26),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL),
        ),
      );
    }

    handleEmoji() {
      if (showEmoji) {
        if (WidgetsBinding.instance!.window.viewInsets.bottom > 0.0) {
          // Keyboard is visible.
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        }
        return emoji();
      } else {
        return const SizedBox();
      }
    }

    handleWillPop() {
      if (showEmoji) {
        context.read<EmojiCubit>().setShowEmoji(false);
      } else {
        Get.back();
      }
      return Future.value(false);
    }

    return Scaffold(
        appBar: appBar(),
        body: WillPopScope(
          onWillPop: handleWillPop,
          child: Column(
            children: [
              dataMessage(),
              textFieldChat(),
              handleEmoji(),
            ],
          ),
        ));
  }
}
